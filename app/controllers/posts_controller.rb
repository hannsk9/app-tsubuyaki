class PostsController < ApplicationController
  
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def show
    @post = Post.find(params[:id])
    @pagy, @comments = pagy(@post.comments)
    @comment = current_user.comments.build #formのパラメータ用にCommentオブジェクトを取得
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url
    else
      @pagy, @posts = pagy(current_user.feed_posts.order(id: :desc))
      unless @post.valid?
        flash[:content] = @post.errors[:content]
      end
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @post.destroy
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end
