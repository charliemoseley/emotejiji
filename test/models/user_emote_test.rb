require "test_helper"

describe UserEmote do
  before do
    @user_emote = UserEmote.new
  end

  it "must be valid" do
    @user_emote.valid?.must_equal true
  end
end
