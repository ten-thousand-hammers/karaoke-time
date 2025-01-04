class SettingsController < ApplicationController
  def index
    @yt_dlp_version = YtDlpManager.version
  end

  def update
    Setting.always_embed = params[:always_embed] == "1"
    redirect_to settings_path, notice: "Settings updated successfully"
  end

  def update_yt_dlp
    result = YtDlpManager.update_binary
    render json: {
      success: result[:success],
      message: result[:message],
      version: YtDlpManager.version
    }
  end
end
