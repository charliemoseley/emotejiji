require "test_helper"

describe User do
  before do
    @user = User.new email: "foo@bar.com", username: "foobar", password: "randomfoo"
  end

  describe "validations" do
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
      bad_user = User.new email: "foo@bar.com", username: "foobaz", password: "randomfoo"
      bad_user.valid?.must_equal false
    end

    it "should allow only unique usernames address" do
      @user.save
      bad_user = User.new email: "foo@baz.com", username: "foobar", password: "randomfoo"
      bad_user.valid?.must_equal false
    end

    it "should only allow passwords of a minimum of 8 characters" do
      @user.password = "short"
      @user.valid?.must_equal false
    end
  end
end
