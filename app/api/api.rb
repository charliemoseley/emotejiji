module API 
  class Router < Grape::API
    version 'v1', using: :path, vendor: 'emotejiji', cascade: false
    format :json
    prefix 'api'

    helpers do
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
    end

    resource :emotes do
      desc "Gets a list of emotes"
      get do
        emotes = Emote.all
        present emotes, with: API::Entities::Emote, root: :emotes
      end
      
      desc "Gets an individual emoticon"
      params do
        requires :id, desc: "Emoticon id."
      end
      get ':id' do
        emote = Emote.find(params[:id]) rescue error!("Unknown id", 404)
        error!("Unknown id", 404) if emote.nil?

        present emote, with: API::Entities::Emote, root: :emote
      end

      desc "Creates a new emote."
      params do
        requires :text, type: String, desc: "The content of your emote."
      end
      post do
        clean_params = sanitize_params(params)
        emote  = Emote.create clean_params.permit(:text, :description, tags: [])

        present emote, with: API::Entities::Emote, root: :emote
      end

      desc "Updates an emote."
      put ':id' do
        emote = Emote.find(params[:id]) rescue error!("Unknown id", 404)
        error!("Unknown id", 404) if emote.nil?

        clean_params = sanitize_params params
        emote.update_attributes clean_params.permit(:text, :description, tags: [])
        present emote, with: API::Entities::Emote, root: :emote
      end

      desc "Raises an exception."
      get :error do
        raise "Unexpected error."
      end
    end
  end

  module Entities
    class Emote < Grape::Entity
      expose :id
      expose :text
      expose :description
      expose :text_rows
      expose :longest_line_length
      expose :tags
    end
  end
end