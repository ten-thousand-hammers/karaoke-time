module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_browser_id?
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
