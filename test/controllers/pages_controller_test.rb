require "test_helper"

describe PagesController do
  it "should get index" do
    get :index
    assert_response :success
  end

end
