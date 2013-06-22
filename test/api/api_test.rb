require "test_helper"

class APISpec < ActionDispatch::IntegrationTest
  before do
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


  describe "User namespace" do
    before do
      @user = Fabricate :user
    end

    describe "GET /api/v1/user/:id" do
      it "should return a user profile" do
        get "/api/v1/users/#{@user.id}"
        user = parse(response)
        user.id.must_equal @user.id
        user.username.must_equal @user.username
        user.emoticons_favorited.must_equal 0
        user.emoticons_created.must_equal 0
      end

      it "should return a 404 with invalid id" do
        get "/api/v1/users/fooobar"
        response.code.must_equal "404"
      end

      it "should work with me instead of a user id"

      describe "counts" do
        before do
          @emote1 = Fabricate.build :emote
          @emote2 = Fabricate.build :emote
          @emote1.create_with @user
          @emote2.create_with @user
          @emote1.favorited_by @user
          @emote2.favorited_by @user
        end

        it "should return a user profile with a valid favorite count" do
          get "/api/v1/users/#{@user.id}"
          user = parse(response)
          user.emoticons_favorited.must_equal 2
        end

        it "should return a user profile with a valid emotes created account" do
          get "/api/v1/users/#{@user.id}"
          user = parse(response)
          user.emoticons_created.must_equal 2
        end

        it "should return the users favorites with the profile" do
          get "/api/v1/users/#{@user.id}", { include_favorites: true }
          user = parse(response)
          user.favorite_emoticons.count.must_equal 2
          user.favorite_emoticons.each do |favorite|
            @emote = favorite.id == @emote1.id ? @emote1 : @emote2
            favorite.id.must_equal @emote.id
            favorite.text.must_equal @emote.text
          end
        end

        it "should return the users favorites as an array of ids" do
          get "/api/v1/users/#{@user.id}", { include_favorites: "list" }
          user = parse(response)
          user.favorite_emoticons.count.must_equal 2
          user.favorite_emoticons.include?(@emote1.id).must_equal true
          user.favorite_emoticons.include?(@emote2.id).must_equal true
        end

        it "should not return the favorite_emoticons field if include_favorites = false" do
          get "/api/v1/users/#{@user.id}", { include_favorites: false }
          user = parse(response)
          user.favorite_emoticons.must_equal nil
        end

        it "should error 400 if favorite_emoticons is not a valid value" do
          get "/api/v1/users/#{@user.id}", { include_favorites: "foobar" }
          response.code.must_equal "400"
        end
      end
    end

    describe "GET /api/v1/users/:user_id/favorites" do
      it "should return an empty array if the user has no favorites" do
        get "/api/v1/users/#{@user.id}/favorites"
        favorites = parse(response)
        favorites.kind_of?(Array).must_equal true
        favorites.empty?.must_equal true
      end

      describe "with favorites" do
        before do
          @emote1 = Fabricate :emote
          @emote2 = Fabricate :emote
          @emote1.favorited_by @user
          @emote2.favorited_by @user
        end

        it "should return a list of the users favorite emotes" do
          get "/api/v1/users/#{@user.id}/favorites"
          favorites = parse(response)
          favorites.count.must_equal 2
          favorites.each do |favorite|
            @emote = favorite.id == @emote1.id ? @emote1 : @emote2
            favorite.id.must_equal @emote.id
            favorite.text.must_equal @emote.text
          end
        end

        it "should return a list of the users favorites that just contains ids of emoticons" do
          get "/api/v1/users/#{@user.id}/favorites", { ids_only: true }
          favorites = JSON.parse(response.body)
          favorites.count.must_equal 2
          favorites.include?(@emote1.id).must_equal true
          favorites.include?(@emote2.id).must_equal true
        end

        it "should return a list of the users favorite emotes with ids_only set to false" do
          get "/api/v1/users/#{@user.id}/favorites", { ids_only: false }
          favorites = parse(response)
          favorites.count.must_equal 2
          favorites.each do |favorite|
            @emote = favorite.id == @emote1.id ? @emote1 : @emote2
            favorite.id.must_equal @emote.id
            favorite.text.must_equal @emote.text
          end
        end

        it "should 400 if you butcher the ids_only optional param" do
          get "/api/v1/users/#{@user.id}/favorites", { ids_only: "foobar" }
          response.code.must_equal "400"
        end
      end
    end

    describe "Post /api/v1/users/:user_id/favorites" do
      before do
        @emote = Fabricate :emote
      end

      it "should return a 400 if no emote id is sent" do
        post "/api/v1/users/#{@user.id}/favorites"
        response.code.must_equal "400"
      end

      it "should return an 404 if the emote id is invalid" do
        post "/api/v1/users/#{@user.id}/favorites", { emoticon_id: "foobar" }
        response.code.must_equal "404"
      end

      it "should create a new favorite emote with a valid id" do
        post "/api/v1/users/#{@user.id}/favorites", { emoticon_id: @emote.id }
        UserEmote.where(kind: "Favorited", user_id: @user.id, emote_id: @emote.id).count.must_equal 1
      end

      it "should not create a duplicate favorite if it already exists" do
        @emote.favorited_by @user
        post "/api/v1/users/#{@user.id}/favorites", { emoticon_id: @emote.id }
        response.code.must_equal "409"
        UserEmote.where(kind: "Favorited", user_id: @user.id, emote_id: @emote.id).count.must_equal 1
      end

      it "should notify you the limit is reached and no more favorites can be added if over 15" do
        (1..15).each { Fabricate(:emote).favorited_by @user }
        post "/api/v1/users/#{@user.id}/favorites", { emoticon_id: @emote.id }
        response.code.must_equal "409"
        UserEmote.where(kind: "Favorited", user_id: @user.id).count.must_equal 15
      end

      it "should return the list of favorites when a new one is added" do
        (1..3).each { Fabricate(:emote).favorited_by @user }
        post "/api/v1/users/#{@user.id}/favorites", { emoticon_id: @emote.id }
        favorites = parse(response)
        favorites.count.must_equal 4
        object_array_includes?(favorites, :id, @emote.id).must_equal true
      end
    end
  end

  def parse(response)
    parsed = JSON.parse(response.body)
    if parsed.kind_of? Array
      parsed.map {|obj| Hashie::Mash.new obj }
    else
      Hashie::Mash.new parsed
    end
  end

  def object_array_includes?(array, field, value)
    included = false
    array.each { |obj| included = true if obj.send(field) == value }
    included
  end
end