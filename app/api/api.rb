class API < Grape::API
  version 'v1', using: :path, vendor: 'emotejiji', cascade: false
  format :json
  prefix 'api'

  resource :emotes do
    desc "Gets a list of emotes"
    get do
      { emotes: "list of emotes" }
    end
    
    desc "Gets an individual emoticon"
    params do
      requires :id, desc: "Emoticon id."
    end
    get ':id' do
      { emote: "a single emote with the id of #{params[:id]}" }
    end

    desc "Raises an exception."
    get :error do
      raise "Unexpected error."
    end
  end
end