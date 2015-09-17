class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  after_create :web_sockets_notify, :notify_post_created


  private

  def web_sockets_notify
    WebsocketRails[:new_post].trigger 'post_created', self.to_json(include: :author)
  end

  def notify_post_created
    Post.connection.execute "NOTIFY posts, '#{self.id}'"
  end

  class << self
    def on_change
      Post.connection.execute "LISTEN posts"
      loop do
        Post.connection.raw_connection.wait_for_notify do |event, pid, post|
          yield post
        end
      end
    ensure
      Post.connection.execute "UNLISTEN posts"
    end
  end
end
