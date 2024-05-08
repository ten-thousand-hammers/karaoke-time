class HomeController < ApplicationController
  def index
  end

  def search
    search_term = params[:search]

    cmd = ["yt-dlp", "-j", "--no-playlist", "--flat-playlist", %(ytsearch10:"#{search_term} karaoke")].join(" ")
    puts cmd
    response = `#{cmd}`
    @results = response
      .split("\n")
      .map { |line| JSON.parse(line) }
      .select { |obj| obj["title"].present? && obj["url"].present? }
  end

  def play
    video_url = "https://www.youtube.com/watch?v=#{params[:id]}"
    title = params[:title]
    id = params[:id]
    ext = "mp4"

    destination_path = File.join("downloads", "#{title}---#{id}.#{ext}")
    unless File.exist?(destination_path)
      download_path = File.join("downloads", "%(title)s---%(id)s.%(ext)s")
      # file_quality = "bestvideo[ext!=webm][height<=1080]+bestaudio[ext!=webm]/best[ext!=webm]"
      file_quality = "mp4"
      cmd = ["yt-dlp", "-f", file_quality, "-o", "\"#{download_path}\"", video_url].join(" ")
      response = system(cmd)
    end

    StreamVideoJob.perform_later(destination_path)

    sleep 2
  end
end
