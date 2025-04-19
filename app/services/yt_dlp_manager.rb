require "open-uri"
require "fileutils"

class YtDlpManager
  BINARY_URL = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"
  BINARY_PATH = Rails.root.join("bin/yt-dlp").to_s

  def self.ensure_binary_exists
    return if File.exist?(BINARY_PATH)
    download_binary
  end

  def self.download_binary
    FileUtils.mkdir_p(File.dirname(BINARY_PATH))
    File.binwrite(BINARY_PATH, URI.open(BINARY_URL).read) # rubocop:disable Security/Open
    FileUtils.chmod(0o755, BINARY_PATH)
  end

  def self.update_binary
    if File.exist?(BINARY_PATH)
      stdout, _stderr, status = Open3.capture3("#{BINARY_PATH} --update-to nightly 2>&1")
      success = status.success?
      {success: success, message: stdout}
    else
      download_binary
      {success: true, message: "Downloaded fresh copy of yt-dlp"}
    end
  end

  def self.version
    return nil unless File.exist?(BINARY_PATH)
    stdout, _stderr, status = Open3.capture3("#{BINARY_PATH} --version 2>&1")
    if status.success?
      stdout.strip
    end
  end
end
