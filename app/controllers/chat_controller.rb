class ChatController < ApplicationController
  before_filter :require_login

  def index
    @recent_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_hour )
  end

  def new_posts
    cur_time = params[:cur_time] ? Time.at(params[:cur_time].to_i) : Time.now
    post_id = ( params[:last_post_id] || 0 ).to_i
    posts = Post.where("id > ? AND created_at > ?", post_id, cur_time)
    render json: {posts: posts}
  end

end