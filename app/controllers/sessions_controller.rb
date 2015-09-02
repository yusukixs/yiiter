class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:account_name], params[:password])
    if user
      session[:user_id] = user.id
    else
      flash.alert = "アカウント名とパスワードが一致しません"
    end
    redirect_to :root
  end
  
  def destroy
    session.delete(:user_id)
    redirect_to :root
  end
end
