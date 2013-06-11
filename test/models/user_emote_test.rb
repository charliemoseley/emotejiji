require "test_helper"

describe UserEmote do
  before do
    @emote = Emote.create text: "foobar", tags: { foo: 1, bar: 1 }
    @user  = User.create  email: "foo@bar.com", username: "foobar",
                          password: "randomfoo", password_confirmation: "randomfoo"

    @user_emote = UserEmote.new kind: 'owner', user_id: @user.id, emote_id: @emote.id,
                                tags: ['foo', 'bar']
  end

  it "should respond to it's attributes and be valid" do
    attrs = [:kind, :user_id, :emote_id, :tags]
    attrs.each do |attr|
      @user_emote.must_respond_to attr
    end
    @user_emote.valid?.must_equal true
  end

  it "should be invalid with a invalid kind" do
    @user_emote.kind = nil;      @user_emote.valid?.must_equal false
    @user_emote.kind = "foobar"; @user_emote.valid?.must_equal false
  end

  it "should be valid with a valid kind" do
    valid = ['owner', 'favorite', 'tagged']
    valid.each do |kind|
      @user_emote.kind = kind
      @user_emote.valid?.must_equal true
    end
  end
end
