module API 
  class Router < Grape::API
    version 'v1', using: :path, vendor: 'emotejiji', cascade: false
    format :json
    prefix 'api'

    before do
      authenticate
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
        clean_params = sanitize_params(params)
        emote  = Emote.create clean_params.permit(:text, :description, tags: [])

        present emote, with: API::Entities::Emote
      end

      desc "Updates an emote."
      put ':id' do
        emote = Emote.find(params.id) rescue error!("Unknown id", 404)
        error!("Unknown id", 404) if emote.nil?

        clean_params = sanitize_params params
        emote.update_attributes clean_params.permit(:text, :description, tags: [])
        present emote, with: API::Entities::Emote
      end

      desc "Raises an exception."
      get :error do
        raise "Unexpected error."
      end
    end

    resource :users do
      get ':id' do
        "user profile get"
      end

      segment '/:user_id' do
        resource :favorites do
          get do
            "favorites get"
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
    end
  end
end