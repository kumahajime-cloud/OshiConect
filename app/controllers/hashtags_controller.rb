class HashtagsController < ApplicationController
  def show
    @hashtag = Hashtag.find_by!(name: params[:name])
    @posts = @hashtag.posts.includes(:user, :hashtags).recent.page(params[:page]).per(20)
  end
end
