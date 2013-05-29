require "test_helper"

class APISpec < ActionDispatch::IntegrationTest
  before do
    @emote1 = Emote.create text: "foobar1", description: "the first foobar",  tags: ["foo", "bar"]
    @emote2 = Emote.create text: "foobar2", description: "the second foobar", tags: ["foo", "baz"]
  end

  describe "GET /api/v1/emotes" do
    it "should respond a list of emotes" do
      get "/api/v1/emotes"
      parse(response).emotes.count.must_equal 2
    end
  end

  describe "GET /api/v1/emotes/:id" do
    it "should respond with a single emote" do
      get "/api/v1/emotes/#{@emote1.id}"
      parse(response).emote.text.must_equal @emote1.text
    end

    it "should error if the id is not valid" do
      get "/api/v1/emotes/foobar"
      response.success?.must_equal false
    end
  end

  describe "POST /api/v1/emotes" do
    it "should create a new emote" do
      post "/api/v1/emotes", { text: "foobar", tags: ["foo", "baz"] }
      returned_emote = parse(response).emote
      returned_emote.text.must_equal "foobar"
      returned_emote.tags.include?("foo").must_equal true
      returned_emote.tags.include?("baz").must_equal true

      get "/api/v1/emotes/#{returned_emote.id}"
      parse(response).emote.id.must_equal returned_emote.id
    end

    it "should error if text is not passed" do
      post "/api/v1/emotes", { foo: "bar" }
      response.success?.must_equal false
    end
  end

  describe "PUT /api/v1/emotes/:id" do
    it "should update the emote" do
      put "/api/v1/emotes/#{@emote1.id}", { text: "moobar", tags: ["overrides tags"] }
      returned_emote = parse(response).emote
      returned_emote.text.must_equal "moobar"
      returned_emote.tags.include?("overrides tags").must_equal true
      returned_emote.tags.include?("foo").must_equal false
      returned_emote.id.must_equal   @emote1.id

      get "/api/v1/emotes/#{@emote1.id}"
      returned_emote = parse(response).emote
      returned_emote.text.must_equal "moobar"
      returned_emote.tags.include?("overrides tags").must_equal true
      returned_emote.tags.include?("foo").must_equal false
    end

    it "should error if the id is not valid" do
      put "/api/v1/emotes/foobar", { text: "moobar" }
      response.success?.must_equal false
    end
  end

  def parse(response)
    Hashie::Mash.new(JSON.parse(response.body))
  end
end