class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  
  def user_signed_in?
    current_user.present?
  end

  def current_user
    return nil if session[:userinfo].nil?
    return nil if session[:userinfo]["email"].nil?

    User.find_by(email: session[:userinfo]["email"])
  end
end
