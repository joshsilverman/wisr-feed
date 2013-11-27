class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    warden.authenticate if warden
  end

  def authenticate_client!
    if !current_user
      render status: 403, nothing: true
    elsif !current_user.is_client?
      render status: 403, nothing: true
    else
      authenticate_user!
    end
  end
end
