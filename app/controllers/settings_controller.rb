class SettingsController < ApplicationController
  def index
  end

  def update
    Setting.always_embed = params[:always_embed] == "1"
    redirect_to settings_path, notice: "Settings updated successfully"
  end
end
