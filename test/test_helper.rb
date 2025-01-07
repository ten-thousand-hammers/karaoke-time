ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_in(user)
      cookies[:_karaoke_time_browser_id] = user.browser_id
    end

    def mock_yt_download(song, returns: ["", "", stub(success?: true)])
      Open3.expects(:capture3).with(
        YtDlpManager::BINARY_PATH,
        "-f", "mp4",
        "-o", File.join("public", "videos", "%(id)s.%(ext)s"),
        "https://www.youtube.com/watch?v=#{song.external_id}"
      ).returns(returns)
    end
  end
end
