require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def wait_for_turbo_frame(selector)
    if has_selector?("turbo-frame#{selector}[busy]", visible: true, wait: 0.25.seconds)
      has_no_selector?("turbo-frame#{selector}[busy]", wait: timeout.presence || 5.seconds)
    end
  end

  def wait_for_turbo_frames(*selectors)
    selectors.each do |selector|
      wait_for_turbo_frame(selector)
    end
  end
end
