require "test_helper"

class APISpec < ActionDispatch::IntegrationTest
  before do
    API::Router

    @emote1 = Emote.create text: "foobar1", description: "the first foobar",  tags: ["foo", "bar"]
    @emote2 = Emote.create text: "foobar2", description: "the second foobar", tags: ["foo", "baz"]
  end

  describe "GET /api/v1/emotes" do
    it "should respond a list of emotes" do
      get "/api/v1/emotes"
      parse(response).count.must_equal 2
    end

    it "should respond with emotes that match the queried tags" do
      get "/api/v1/emotes/", { tags: ["foo", "baz"] }
      emotes = parse(response)
      emotes.count.must_equal 1
      emotes.first.id.must_equal @emote2.id
    end
  end

  describe "GET /api/v1/emotes/:id" do
    it "should respond with a single emote" do
      get "/api/v1/emotes/#{@emote1.id}"
      parse(response).text.must_equal @emote1.text
    end

    it "should error if the id is not valid" do
      get "/api/v1/emotes/foobar"
      response.success?.must_equal false
    end
  end

  describe "POST /api/v1/emotes" do
    it "should create a new emote" do
      post "/api/v1/emotes", { text: "foobar", tags: ["foo", "baz"] }
      returned_emote = parse(response)
      returned_emote.text.must_equal "foobar"
      returned_emote.tags.include?("foo").must_equal true
      returned_emote.tags.include?("baz").must_equal true

      get "/api/v1/emotes/#{returned_emote.id}"
      parse(response).id.must_equal returned_emote.id
    end

    it "should error if text is not passed" do
      post "/api/v1/emotes", { foo: "bar" }
      response.success?.must_equal false
    end
  end

  describe "PUT /api/v1/emotes/:id" do
    # Currently invalid test
    it "should update the emote" #do
    #  put "/api/v1/emotes/#{@emote1.id}", { text: "moobar", tags: { "overrides tags" => 1 } }
    #  returned_emote = parse(response)
    #  returned_emote.text.must_equal "moobar"
    #  returned_emote.tags.include?("overrides tags").must_equal true
    #  returned_emote.tags.include?("foo").must_equal false
    #  returned_emote.id.must_equal   @emote1.id
    #
    #  get "/api/v1/emotes/#{@emote1.id}"
    #  returned_emote = parse(response).emote
    #  returned_emote.text.must_equal "moobar"
    #  returned_emote.tags.include?("overrides tags").must_equal true
    #  returned_emote.tags.include?("foo").must_equal false
    #end

    it "should error if the id is not valid" do
      put "/api/v1/emotes/foobar", { text: "moobar" }
      response.success?.must_equal false
    end
  end

  describe "GET /api/v1/tags/list" do
    it "should return a list of all tags"
  end

  describe "GET /api/v1/users/:user_id/favorites" do
    it "should return a list of the user's favorites" #do
    #  user = Fabricate :user
    #  get "/api/v1/users/#{user.id}/favorites"
    #  response.must_equal "favorites get"
    #end
  end

  def parse(response)
    parsed = JSON.parse(response.body)
    if parsed.kind_of? Array
      parsed.map {|obj| Hashie::Mash.new obj }
    else
      Hashie::Mash.new parsed
    end
  end
end