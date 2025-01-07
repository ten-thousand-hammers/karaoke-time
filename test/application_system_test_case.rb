require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["CI"]
    driven_by :selenium, using: :headless_chrome do |option|
      option.add_argument("no-sandbox")
      option.add_argument("--disable-dev-shm-usage")
    end
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

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
