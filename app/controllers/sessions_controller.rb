class SessionsController < ApplicationController

  def new

  end

  def create

  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end