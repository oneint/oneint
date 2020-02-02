class AccountsController < ApplicationController
  def profile
  end

  def update
    if current_user.update_with_password(account_attributes)
      flash[:notice] = 'Your account was updated.'
      bypass_sign_in current_user
      redirect_to workspace_path(@workspace)
    else
      render :profile
    end
  end

  private

  def account_attributes
    params[:user].permit(:email, :current_password, :password, :password_confirmation)
  end
end