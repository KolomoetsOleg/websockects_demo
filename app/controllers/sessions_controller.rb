class SessionsController < ApplicationController

  def new

  end

  def create
    user = login(session_params[:username], session_params[:password])
    if user
      cookies[:connection_type] = params[:connection_type]
      redirect_to home_index_path
    else
      redirect_to :back
    end
  end

  private

  def session_params
    params.permit(:username, :password)
  end
end