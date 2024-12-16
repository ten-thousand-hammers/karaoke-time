module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
    before_action :logged_in_using_browser_id?
  end

  def logged_in_using_omniauth?
    return unless ENV["AUTH0_CLIENT_ID"].present?
    return unless ENV["AUTH0_CLIENT_SECRET"].present?
    return unless ENV["AUTH0_DOMAIN"].present?

    # Let's check for a user in the session
    if session[:userinfo].present? && session[:userinfo]["sub"].present?
      user = User.find_by(auth0_id: session[:userinfo]["sub"])
      if user.present?
        if user.browser_id.blank? && cookies[:_karaoke_time_browser_id].present?
          user.browser_id = cookies[:_karaoke_time_browser_id]
          user.save!
        end

        return
      end

      redirect_to '/auth/redirect/'
    end
  end

  def logged_in_using_browser_id?
    return unless browser_id.present?

    user = User.find_or_initialize_by(browser_id: browser_id)
    if user.new_record?
      user.save!
      redirect_to edit_profile_path(user), notice: "Looks like it's the first time you're using Karaoke Time. Please add a Nickname and Avatar."
    end
  end
end
