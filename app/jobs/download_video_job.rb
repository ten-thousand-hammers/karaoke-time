require "open3"

class DownloadVideoJob < ApplicationJob
  queue_as :default

  def perform(song)
    return if song.downloaded

    extension = "mp4"
    if File.exist?(File.join("public", "videos", "#{song.external_id}.#{extension}"))
      song.update!(
        downloaded: true,
        download_status: :completed,
        path: File.join("videos", "#{song.external_id}.#{extension}")
      )
      update_performance_status(song)
      return
    end

    video_url = "https://www.youtube.com/watch?v=#{song.external_id}"
    download_path = File.join("public", "videos", "%(id)s.%(ext)s")
    file_quality = extension
    cmd = [
      YtDlpManager::BINARY_PATH,
      "-f", file_quality,
      "-o", download_path,
      video_url
    ]

    begin
      stdout, stderr, status = Open3.capture3(*cmd)
      
      if status.success?
        song.update!(
          downloaded: true,
          download_status: :completed,
          path: File.join("videos", "#{song.external_id}.#{extension}")
        )
        update_performance_status(song)
      else
        song.update!(
          download_status: :failed,
          download_error: stderr
        )
        update_performance_status(song)
      end
    rescue StandardError => e
      song.update!(
        download_status: :failed,
        download_error: e.message
      )
      update_performance_status(song)
    end
  end

  private

  def update_performance_status(song)
    performance = Performance.instance
    if performance.up_next_song_id == song.id
      performance.update!(up_next_download_status: song.download_status)
    end
  end
end
