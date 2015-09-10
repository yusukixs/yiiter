class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  class Forbidden < StandardError; end
  
  private 
  # ログイン中かどうかを判定する
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  # ログイン中かどうかを判定するヘルパーメソッドを追加
  helper_method :current_user
  
  # ログインが必要かどうか
  def login_required
    raise Forbidden unless current_user
  end
  
  # 管理者かどうかを判定する
  def admin_user
    if session[:user_id]
      User.find_by(id: session[:user_id]).administrator
    else
      false
    end
  end
  # 管理者かどうかを判定するヘルパーメソッドを追加
  helper_method :admin_user
end
