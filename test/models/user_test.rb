require "test_helper"

describe User do
  describe "validations" do
    before do
      @user = User.new email: "foo@bar.com", username: "foobar",
                       password: "randomfoo", password_confirmation: "randomfoo"
    end

    it "should be valid with valid attributes" do
      @user.valid?.must_equal true
    end

    it "should allow only valid email address" do
      @user.valid?.must_equal true
      @user.email = "butchered email"
      @user.valid?.must_equal false
    end

    it "should allow only unique email address" do
      @user.save
      bad_user = User.new email: "foo@bar.com", username: "foobaz",
                          password: "randomfoo", password_confirmation: "randomfoo"
      bad_user.valid?.must_equal false
    end

    it "should allow only unique usernames address" do
      @user.save
      bad_user = User.new email: "foo@baz.com", username: "foobar",
                          password: "randomfoo", password_confirmation: "randomfoo"
      bad_user.valid?.must_equal false
    end

    it "should only allow passwords of a minimum of 8 characters" do
      @user.password = "short"
      @user.valid?.must_equal false
    end
  end

  describe "relationships" do
    before do
      @user = User.create email: "foo@bar.com", username: "foobar",
                          password: "randomfoo", password_confirmation: "randomfoo"
    end

    it "should be able to respond to it's relationships" do
      relations = [:created_emotes, :favorited_emotes, :tagged_emotes]
      relations.each do |relation|
        @user.must_respond_to relation
        @user.send(relation).must_equal []
      end
    end

    describe "should return" do
      before do
        @emote1 = Emote.create text: "foobar", tags: { foo: 1, bar: 1 }
        @emote2 = Emote.create text: "foobaz", tags: { foo: 1, baz: 1 }
      end

      it "valid emotes created by this user" do
        UserEmote.create kind: "Owner", user_id: @user.id, emote_id: @emote1.id
        UserEmote.create kind: "Owner", user_id: @user.id, emote_id: @emote2.id

        @user.created_emotes.length.must_equal 2
        @user.created_emotes.include?(@emote1).must_equal true
        @user.created_emotes.include?(@emote2).must_equal true
      end

      it "valid emotes tagged by this user" do
        UserEmote.create kind: "Tagged", user_id: @user.id, emote_id: @emote1.id
        UserEmote.create kind: "Tagged", user_id: @user.id, emote_id: @emote2.id

        @user.tagged_emotes.length.must_equal 2
        @user.tagged_emotes.include?(@emote1).must_equal true
        @user.tagged_emotes.include?(@emote2).must_equal true
      end

      it "valid emotes favorited by this user" do
        UserEmote.create kind: "Favorited", user_id: @user.id, emote_id: @emote1.id
        UserEmote.create kind: "Favorited", user_id: @user.id, emote_id: @emote2.id

        @user.favorited_emotes.length.must_equal 2
        @user.favorited_emotes.include?(@emote1).must_equal true
        @user.favorited_emotes.include?(@emote2).must_equal true
      end
    end
  end

  describe "finders" do
    before do
      @user1 = User.create email: "foo@bar.com", username: "foobar",
                           password: "randomfoo", password_confirmation: "randomfoo"
      @user2 = User.create email: "foo@baz.com", username: "foobaz",
                           password: "randombaz", password_confirmation: "randombaz"
    end

    it "should be able to find a user by either email or username" do
      User.find_by_username_or_email("foo@bar.com").id.must_equal @user1.id
      User.find_by_username_or_email("foobar").id.must_equal      @user1.id
      User.find_by_username_or_email("foo@baz.com").id.must_equal @user2.id
      User.find_by_username_or_email("foobaz").id.must_equal      @user2.id
    end
  end
end
