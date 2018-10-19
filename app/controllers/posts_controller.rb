class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc).all
  end

  def show
    @post = Post.find(params[:id]).decorate
  end
end
