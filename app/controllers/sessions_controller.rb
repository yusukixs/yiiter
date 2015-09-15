class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:account_name], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to :root
    else
      flash.alert = "アカウント名とパスワードが一致しません"
      redirect_to :login
    end
  end
  
  def destroy
    session.delete(:user_id)
    redirect_to :root
  end
end
