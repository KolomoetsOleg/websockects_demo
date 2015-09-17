class SessionsController < ApplicationController

  def new

  end

  def create
    user = login(session_params[:username], session_params[:password])
    if user
      cookies[:connection_type] = params[:connection_type]
      redirect_to chat_index_path
    else
      redirect_to :back
    end
  end

  def destroy
    logout
    cookies[:connection_type] = 0
    redirect_to root_path
  end

  private

  def session_params
    params.permit(:username, :password)
  end
end