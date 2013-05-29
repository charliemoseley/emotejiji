require "test_helper"

class APISpec < ActionDispatch::IntegrationTest
  before do
    @emote1 = Emote.create text: "foobar1", description: "the first foobar"
    @emote2 = Emote.create text: "foobar2", description: "the second foobar"
  end

  describe "/api/v1/emotes" do
    it "with GET should respond a list of emotes" do
      get "/api/v1/emotes"
      parse(response).emotes.must_equal "list of emotes"
    end
  end

  def parse(response)
    Hashie::Mash.new(JSON.parse(response.body))
  end
end