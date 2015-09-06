class AccountsController < ApplicationController
  # ログイン必須
  before_action :login_required
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
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
    params.require(:account).permit(:account_name, :full_name, :password, :password_confirmation, :email)
  end
end
