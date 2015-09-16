class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  after_create :web_sockets_notify


  private

  def web_sockets_notify
    WebsocketRails[:new].trigger 'new_post', self
  end
end
