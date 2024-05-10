class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :server_url

  def user_signed_in?
    current_user.present?
  end

  def current_user
    return nil if session[:userinfo].nil?
    return nil if session[:userinfo]["email"].nil?

    User.find_by(email: session[:userinfo]["email"])
  end

  def server_url
    uri = URI.parse(request.original_url)
    uri.path = ""
    uri.query = nil
    uri.to_s
  end
end
