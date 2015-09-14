class TopController < ApplicationController
  def index
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    @articles = Article.all.readable_for(current_user).order(released_at: :desc).page(params[:page])
  end
  
  def about
    
  end
end
