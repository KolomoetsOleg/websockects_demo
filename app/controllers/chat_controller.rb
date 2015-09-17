class ChatController < ApplicationController
  include ActionController::Live

  before_filter :require_login

  def index
    @recent_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_hour ).includes(:author)
    render stream: true
  end

  def create
    post = Post.new(content: params[:text], user_id: params[:user_id])
    if post.save
      render json: {success: true}
    else
      render json: {success: false, message: "Failed to create post." }, status: 500
    end
  end

  def new_posts
    cur_time = params[:cur_time] ? Time.at(params[:cur_time].to_i) : Time.now
    post_id = ( params[:last_post_id] || 0 ).to_i
    posts = Post.where("id > ? AND created_at > ?", post_id, cur_time).includes(:author)
    render json: {posts: posts.to_json(include: :author )}
  end

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    begin
      Post.on_change do |id|
        post = Post.find(id)
        sse.write(post.to_json(include: :author ))
      end
    rescue IOError
      # Client Disconnected
    ensure
      sse.close
    end
    render nothing: true
  end

end