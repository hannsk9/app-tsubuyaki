class PostsController < ApplicationController
  
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def show
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "つぶやきを投稿しました。"
      redirect_to root_url
    else
      @pagy, @posts = pagy(current_user.posts.order(id: :desc))
      flash.now[:danger] = "つぶやきの投稿に失敗しました。"
      render 'toppages/index'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "つぶやきを削除しました。"
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
