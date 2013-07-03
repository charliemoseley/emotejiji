class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_username_or_email(params[:session][:username_or_email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_url
    else
      # Used for if the user needs to register
      @user = User.new

      @errors = { kind: "Login Error", errors: ['Invalid username/email password combination'] }
      render 'users/new', layout: 'simple'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
