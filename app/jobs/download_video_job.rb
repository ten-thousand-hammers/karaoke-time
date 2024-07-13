class DownloadVideoJob < ApplicationJob
  queue_as :default

  def perform(song)
    return if song.downloaded

    extension = "mp4"
    if File.exist?(File.join("public", "videos", "#{song.external_id}.#{extension}"))
      song.update!(
        downloaded: true,
        File.join("videos", "#{song.external_id}.#{file_quality}")
      )
      return
    end

    video_url = "https://www.youtube.com/watch?v=#{song.external_id}"
    download_path = File.join("public", "videos", "%(id)s.%(ext)s")
    file_quality = extension # "bestvideo[ext!=webm][height<=1080]+bestaudio[ext!=webm]/best[ext!=webm]"
    cmd = [
      "yt-dlp",
      "-f", file_quality,
      "-o", "\"#{download_path}\"", video_url
    ].join(" ")

    stdout_and_stderr, status = Open3.capture2e(cmd)
    exit_code = status.exitstatus

    song.update!(
      downloaded: exit_code == 0,
      download_error: stdout_and_stderr,
      download_status: exit_code,
      path: File.join("videos", "#{song.external_id}.#{file_quality}")
    )
  end
end
