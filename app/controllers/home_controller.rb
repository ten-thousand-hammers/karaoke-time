class HomeController < ApplicationController
  def index
  end

  def skip
    redirect_to "/auth/redirect/" unless session[:userinfo].present?

    if params[:act_id].present?
      act = Act.find(params[:act_id])
      SkipActJob.perform_later(act)
    elsif params[:up_next].present?
      SkipUpNextJob.perform_later
    else
      NextVideoJob.perform_later
    end

    head :no_content
  end

  def prev_song
    PrevVideoJob.perform_later
    redirect_back(fallback_location: root_path)
  end

  def next_song
    NextVideoJob.perform_later(wait: 0.seconds)
    redirect_back(fallback_location: root_path)
  end

  def pause_song
    current_performance.toggle_pause!
    head :ok
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
      size: 160
    )
    send_data png.to_s, type: "image/png", disposition: "inline"
  end
end
