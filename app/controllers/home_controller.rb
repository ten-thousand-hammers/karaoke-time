class HomeController < ApplicationController
  helper_method :server_url

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
    QueueVideoJob.perform_later(params[:id], params[:title], "Nate")

    head :no_content
  end

  def splash
    if params[:id].present?
      QueueVideoJob.set(wait: 5.seconds).perform_later(params[:id], "Jason Mraz - I'm Yours (Karaoke Version)", "Nate")
    end
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
