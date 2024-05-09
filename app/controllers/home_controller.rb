class HomeController < ApplicationController
  helper_method :server_url

  include Secured

  def index
    @user = session[:userinfo]
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

    @results.each do |item|
      song = Song.find_or_create_by(external_id: item["id"]) do |s|
        s.name = item["title"]
        s.url = item["url"]
        s.duration = item["duration"]
        s.thumbnails = item["thumbnails"]
      end
    end
  end

  def play
    permitted_params = params.permit(:id)
    QueueVideoJob.perform_later(
      permitted_params[:id],
      "Nate"
    )

    head :no_content
  end

  def qrcode
    qr = RQRCode::QRCode.new(server_url)
    png = qr.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    send_data png.to_s, type: 'image/png', disposition: 'inline'
  end

  private

  def server_url
    uri = URI.parse(request.original_url)
    uri.path = ""
    uri.query = nil
    uri.to_s
  end
end
