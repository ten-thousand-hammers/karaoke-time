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
    
    @title = params[:title]
    @id = params[:id]
    @ext = "mp4"

    destination_path = File.join("public", "videos", "#{@title}---#{@id}.#{@ext}")
    DownloadVideoJob.perform_now(video_url) unless File.exist?(destination_path)
  end
end
