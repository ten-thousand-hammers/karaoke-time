class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :server_url
  before_action :set_browser_id

  def set_browser_id
    session[:browser_id] = cookies[:karaoke_time__browser_id] if cookies[:karaoke_time__browser_id].present?
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    if session[:browser_id].present?
      User.find_by(browser_id: session[:browser_id])
    elsif session[:userinfo].present? && session[:userinfo]["sub"].present?
      User.find_by(auth0_id: session[:userinfo]["sub"])
    elsif cookies[:karaoke_time__browser_id].present?
      user = User.find_by(browser_id: cookies[:karaoke_time__browser_id])
      session[:browser_id] = user.browser_id if user.present?
      user
    else
      nil
    end
  end

  def server_url
    return ENV["SERVER_URL"] if ENV["SERVER_URL"].present?

    uri = URI.parse(request.original_url)
    uri.path = ""
    uri.query = nil
    uri.to_s
  end

  def current_performance
    Performance.instance
  end
end
