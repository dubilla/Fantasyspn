class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
    @posts = @season.posts.published.order(published_at: :desc)
  end
end
