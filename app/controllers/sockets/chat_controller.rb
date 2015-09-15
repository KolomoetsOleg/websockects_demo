class Sockets::ChatController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    # controller_store[:test_var] = 0
  end

  def new
    if message[:text] == "return false"
      trigger_failure false
    else
      trigger_success true
    end
  end
end