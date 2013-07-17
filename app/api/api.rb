# TODO: (refactor) Break this API file into multiple smaller chunks.
# TODO: (refactor) Rename the /emotes/ route to /emoticons/.
# TODO: Require many of the API methods to have a current user set to be performed.

module API
  class Router < Grape::API
    version 'v1', using: :path, vendor: 'emotejiji', cascade: false
    format :json

    before do
      #authenticate
    end

    helpers do
      def current_user=(user)
        @current_user = user
      end

      def current_user
        @current_user ||= User.find_by(remember_token: cookies[:remember_token])
      end

      def session
        Rack::Request.new(env).session
        #raise request.session[:_csrf_token].inspect
      end

      def sanitize_params(params)
        remove = [:route_info, :options, :params, :version, :id]
        clean_params = hash_multi_delete params, remove
        ActionController::Parameters.new clean_params.to_hash
      end

      def hash_multi_delete(hash, sym_arr)
        sym_arr.each do |sym|
          hash.delete(sym)
        end
        hash
      end

      def authenticate
        # TODO: Hacky, I don't like this but it works and I can figure out something more elegant later
        unless Rails.env == "test"
          error!('Unauthorized', 401) unless headers['X-Xsrf-Token'] == session[:_csrf_token]
        end
      end
    end

    resource :emotes do
      desc "Gets a list of emotes"
      params do
        optional :tags, type: Array
      end
      get do
        if params.tags
          emotes = Emote.all_tags params.tags
        else
          emotes = Emote.all
        end
        present emotes, with: API::Entities::Emote
      end
      
      desc "Gets an individual emoticon"
      params do
        requires :id, desc: "Emoticon id."
      end
      get ':id' do
        emote = Emote.find(params.id) rescue error!("Unknown id", 404)
        error!("Unknown id", 404) if emote.nil?

        present emote, with: API::Entities::Emote
      end

      desc "Creates a new emote."
      params do
        requires :text, type: String, desc: "The content of your emote."
      end
      post do
        existing = Emote.find_by_text params.text
        unless existing.nil?
          error!("An emoticon with that content already exists: #{existing.id}", 409)
        end

        clean_params = sanitize_params(params)
        emote  = Emote.create clean_params.permit(:text, :description, :display_rows, :display_columns, tags: [])

        present emote, with: API::Entities::Emote
      end

      desc "Updates an emote."
      put ':id' do
        emote = Emote.find(params.id) rescue error!("Unknown id", 404)
        error!("Unknown id", 404) if emote.nil?
        error!("Unknown user", 404) if current_user.nil?

        clean_params = sanitize_params params
        emote.update_attributes clean_params.permit(:text, :description, :display_rows, :display_columns)
        emote.add_tags(current_user, clean_params[:tags])
        present emote, with: API::Entities::Emote
      end

      desc "Raises an exception."
      get :error do
        raise "Unexpected error."
      end
    end

    resource :users do
      params do
        requires :id, type: String
        optional :include_favorites, type: String
      end
      get ':id' do
        unless params.include_favorites.nil?
          error!("include_favorites must be true, false, or list", 400) unless ["true", "false", "list"].include? params.include_favorites
        end

        if params.id == "me"
          user = current_user
          error!("Unknown id", 404) if user.nil?
        else
          user = User.find(params.id) rescue error!("Unknown id", 404)
        end

        present user, with: API::Entities::User
      end

      segment '/:user_id' do
        resource :favorites do
          params do
            optional :ids_only, type: Boolean
          end
          get do
            if params.user_id == "me"
              user = current_user
              error!("Unknown id", 404) if user.nil?
            else
              user = User.find(params.user_id) rescue error!("Unknown id", 404)
            end

            favorites = user.favorited_emotes
            unless params.ids_only
              present favorites, with: API::Entities::Emote
            else
              favorites.map{ |e| e.id }
            end
          end

          params do
            # is broken in grape framework; using hacky middleware to fix it
            # https://groups.google.com/forum/#!topic/ruby-grape/VELsU47wXkU
            requires :emoticon_id, type: String
          end
          post do
            if params.user_id == "me"
              user = current_user
              error!("Unknown user id", 404) if user.nil?
            else
              user = User.find(params.user_id) rescue error!("Unknown id", 404)
            end
            emote = Emote.find(params.emoticon_id) rescue error!("Unknown emote id", 404)

            total_favorites = UserEmote.where(kind: "Favorited", user_id: user.id).count
            error!("Maximum number of favorites reached", 409) if total_favorites >= 15

            if UserEmote.where(kind: "Favorited", user_id: user.id, emote_id: emote.id).count >= 1
              error!("Emoticon with id of #{emote.id} is already a favorite of user #{user.id}", 409)
            end

            emote.favorited_by(user)
            present user.favorited_emotes, with: API::Entities::Emote
          end

          # TODO: Write error handling
          params do
            requires :emoticon_id, type: String
          end
          delete do
            if params.user_id == "me"
              user = current_user
              error!("Unknown user id", 404) if user.nil?
            else
              user = User.find(params.user_id) rescue error!("Unknown id", 404)
            end
            emote_ref = UserEmote.where(kind: "Favorited", user_id: user.id, emote_id: params.emoticon_id)
            error!("User doesn't have that emoticon in their favorites", 404) if emote_ref.empty?

            emote_ref.first.delete
          end
        end
      end
    end
  end

  module Entities
    class Emote < Grape::Entity
      expose :id
      expose :text
      expose :description
      expose :text_rows
      expose :max_length
      expose :tags
      expose :display_rows
      expose :display_columns
      expose(:created_at) { |emoticon, options| emoticon.created_at.iso8601 }
      expose(:updated_at) { |emoticon, options| emoticon.updated_at.iso8601 }
    end

    class User < Grape::Entity
      expose :id
      expose :username
      expose(:emoticons_favorited) { |user, options| user.favorited_emotes.count }
      expose(:emoticons_created) { |user, options| user.created_emotes.count }

      # Optionals
      expose(:favorite_emoticons,
             if: lambda{ |user, options|
                   include_favorites = options[:env]["api.endpoint"].params.include_favorites
                   return_state = true
                   return_state = false if include_favorites == nil
                   return_state = false if include_favorites == "false"
                   return_state
             }) do
        |user, options|
        include_favorites = options[:env]["api.endpoint"].params.include_favorites
        if include_favorites == "true"
          user.favorited_emotes.map { |emote| API::Entities::Emote.new(emote) }
        elsif include_favorites == "list"
          user.favorited_emotes.map{ |emote| emote.id }
        end
      end
    end
  end
end