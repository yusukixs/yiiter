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

  def new
    @user = User.new
    @user.build_image
  end

  def edit
    @user = User.find(params[:id])
    @user.build_image unless @user.image
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'ユーザーを登録しました。' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to @user, notice: "アカウント情報を更新しました。"
    else
      render "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'ユーザーを削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      attrs = [:account_name, :full_name, :password, :password_confirmation, :email]
      # 管理者の場合、管理者フラグをパラメータとして許可
      attrs << :administrator if current_user.administrator?
      # ユーザーアイコンをパラメータとして許可
      attrs << { image_attributes: [:_destroy, :id, :uploaded_image] }
      params.require(:user).permit(attrs)
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
