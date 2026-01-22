class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @posts = @user.posts.includes(:hashtags).recent.page(params[:page]).per(20)
    @oshis = @user.oshis
  end

  def edit
    authorize_user!
  end

  def update
    authorize_user!

    if @user.update(user_params)
      redirect_to profile_path(@user), notice: 'プロフィールを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id] || current_user.id)
  end

  def authorize_user!
    unless @user == current_user
      redirect_to root_path, alert: '権限がありません。'
    end
  end

  def user_params
    params.require(:user).permit(:username, :bio, :profile_image)
  end
end
