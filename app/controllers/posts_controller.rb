class PostsController < ApplicationController
  def index
    @season = Season.current
    @posts = @season ? @season.posts.published.order(published_at: :desc) : Post.none
    render "seasons/show"
  end

  def show
    @post = Post.find(params[:id]).decorate
  end
end
