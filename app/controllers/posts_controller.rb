class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :hashtags).recent.page(params[:page]).per(20)
  end

  def show
    @post = Post.includes(:user, :hashtags, :likes).find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path, notice: '投稿を作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: '投稿を削除しました。'
  end

  def like
    unless current_user.liked?(@post)
      current_user.likes.create(post: @post)
    end
    redirect_back(fallback_location: root_path)
  end

  def unlike
    like = current_user.likes.find_by(post: @post)
    like&.destroy
    redirect_back(fallback_location: root_path)
  end

  def search
    if params[:query].present?
      @posts = Post.includes(:user, :hashtags)
                   .where('content LIKE ?', "%#{params[:query]}%")
                   .recent
                   .page(params[:page]).per(20)
    else
      @posts = Post.none
    end
    render :index
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to root_path, alert: '権限がありません。'
    end
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
