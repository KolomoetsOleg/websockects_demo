class HomeController < ApplicationController

  def index
    @users = [
        { id: 1 },
        { id: 2 },
        { id: 3 }
    ]
  end
end