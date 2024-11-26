class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :server_url

  def user_signed_in?
    current_user.present?
  end

  def current_user
    return nil if session[:userinfo].nil?
    return nil if session[:userinfo]["sub"].nil?

    User.find_by(auth0_id: session[:userinfo]["sub"])
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
