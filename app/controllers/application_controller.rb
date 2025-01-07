class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :server_url

  def browser_id
    return @browser_id if defined?(@browser_id)
    return if cookies[:_karaoke_time_browser_id].blank?
    return unless cookies[:_karaoke_time_browser_id].starts_with?("{")
    return unless cookies[:_karaoke_time_browser_id].ends_with?("}")

    cookie_data = JSON.parse(cookies[:_karaoke_time_browser_id])
    return unless cookie_data["id"].present?

    @browser_id = cookie_data["id"]
    @browser_id
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    if browser_id.present?
      User.find_by(browser_id: browser_id)
    elsif cookies[:_karaoke_time_browser_id].present?
      User.find_by(browser_id: cookies[:_karaoke_time_browser_id])
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
