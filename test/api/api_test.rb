require "test_helper"

class APISpec < ActionDispatch::IntegrationTest
  describe "emoticons" do
    it "should respond to get" do
      get "/api/v1/emotes"

      assert response.ok?
    end
  end
end