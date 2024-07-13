class SearchController < ApplicationController
  include Secured

  def index
    search_term = params[:search]

    if search_term.present?
      cmd = ["yt-dlp", "-j", "--no-playlist", "--flat-playlist", %(ytsearch10:"#{search_term} karaoke")].join(" ")
      response = `#{cmd}`

      @results = response
        .split("\n")
        .map { |line| JSON.parse(line) }
        .select { |obj| obj["title"].present? && obj["url"].present? }

      @songs = @results.map do |item|
        song = Song.find_or_create_by(external_id: item["id"]) do |s|
          s.name = item["title"]
          s.url = item["url"]
          s.duration = item["duration"]
          s.thumbnails = item["thumbnails"]
        end
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def play
    permitted_params = params.permit(:id)
    song = Song.find_by(external_id: permitted_params[:id])

    QueueVideoJob.perform_later(song, current_user)

    respond_to do |format|
      format.html {
        head :no_content
      }

      format.turbo_stream {
        flash.now[:notice] = "#{song.name} has been queued"
      }
    end
  end
end
