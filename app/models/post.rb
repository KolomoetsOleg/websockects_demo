class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  after_create :web_sockets_notify, :notify_post_created


  private

  def web_sockets_notify
    WebsocketRails[:new].trigger 'new_post', self.to_json(include: :author)
  end

  def notify_post_created
    Post.connection.execute "NOTIFY posts, 'data'"
  end
end
