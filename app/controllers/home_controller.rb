class HomeController < ApplicationController
  before_filter :require_login

  def index
    @recent_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_hour )
  end
end