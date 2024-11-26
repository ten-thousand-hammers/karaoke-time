require 'open-uri'
require 'fileutils'

class YtDlpManager
  BINARY_URL = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
  BINARY_PATH = Rails.root.join('bin/yt-dlp').to_s

  def self.ensure_binary_exists
    return if File.exist?(BINARY_PATH)
    download_binary
  end

  def self.download_binary
    FileUtils.mkdir_p(File.dirname(BINARY_PATH))
    File.open(BINARY_PATH, 'wb') do |file|
      file.write(URI.open(BINARY_URL).read)
    end
    FileUtils.chmod(0755, BINARY_PATH)
  end

  def self.update_binary
    if File.exist?(BINARY_PATH)
      output = `#{BINARY_PATH} -U 2>&1`
      success = $?.success?
      {success: success, message: output}
    else
      download_binary
      {success: true, message: "Downloaded fresh copy of yt-dlp"}
    end
  end

  def self.version
    return nil unless File.exist?(BINARY_PATH)
    version = `#{BINARY_PATH} --version 2>&1`.strip
    $?.success? ? version : nil
  end
end
