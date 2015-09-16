class Sockets::ChatController < WebsocketRails::BaseController
  def initialize_session

  end

  def new
    post = Post.new(content: message[:text], user_id: message[:user_id])
    if post.save
      WebsocketRails[:new].trigger 'new_post', post
    end
  end

end