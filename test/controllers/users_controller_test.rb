require "test_helper"

describe UsersController do
  it "should get new" do
    get :new
    assert_response :success
  end

  it "should get create" do
    get :create
    assert_response :success
  end

  it "should get login" do
    get :login
    assert_response :success
  end

end
