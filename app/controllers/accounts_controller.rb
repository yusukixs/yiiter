class AccountsController < ApplicationController
  # ログイン必須
  before_action :login_required
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
    @user.build_image unless @user.image
  end

  def update
    @user = current_user
    @user.assign_attributes(account_params)
    if @user.save
      redirect_to :account, notice: "アカウント情報を更新しました。"
    else
      render "edit"
    end
  end
  
  private
  def account_params
    attrs = [:account_name, :full_name, :password, :password_confirmation, :email]
    # ユーザーアイコンをパラメータとして許可
    attrs << { image_attributes: [:_destroy, :id, :uploaded_image] }
    params.require(:account).permit(attrs)
  end
end
