class UsersController < ApplicationController
  # ログイン必須
  before_action :login_required, except: :show
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    # 読み込み可能な記事一覧を取得
    @articles = @user.articles.readable_for(current_user).order(released_at: :desc).page(params[:page])
    if params[:format].in?(["jpg", "gif", "png"])
      send_image
    else
      render "show"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def send_image
      if @user.image.present?
        send_data @user.image.data, type: @user.image.content_type, disposition: "inline"
      else
        raise NotFound
      end
    end
    
  # 自分自身のページかどうかを判定する
  def is_myself
    params[:id].to_i == session[:user_id]
  end
  # 自分自身のページかどうかを判定するヘルパーメソッドを追加
  helper_method :is_myself
end
