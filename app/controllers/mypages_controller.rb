class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = current_user.posts.includes(:hashtags).recent.page(params[:page]).per(20)
    @oshis = current_user.oshis
  end

  def liked_posts
    @posts = current_user.liked_posts.includes(:user, :hashtags).recent.page(params[:page]).per(20)
    render :show
  end
end
