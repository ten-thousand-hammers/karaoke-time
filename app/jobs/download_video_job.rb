class DownloadVideoJob < ApplicationJob
  queue_as :default

  def perform(video_url, stream_after_download: false)
    download_path = File.join("public", "videos", "%(title)s---%(id)s.%(ext)s")
    # file_quality = "bestvideo[ext!=webm][height<=1080]+bestaudio[ext!=webm]/best[ext!=webm]"
    file_quality = "mp4"
    cmd = ["yt-dlp", "-f", file_quality, "-o", "\"#{download_path}\"", video_url].join(" ")
    response = system(cmd)
  end
end
