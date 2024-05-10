class SplashController < ApplicationController
  def index
    @performance = Performance.instance

    # @performance.now_playing_song = Song.find_by(external_id: params[:now_playing_song]) if params[:now_playing_song].present? 
    # @performance.now_playing_user = params[:now_playing_singer] if params[:now_playing_singer].present? 

    # @performance.up_next_song = Song.find_by(external_id: params[:up_next_song]) if params[:up_next_song].present? 
    # @performance.up_next_user = params[:up_next_singer] if params[:up_next_singer].present? 

    if params[:id].present?
      QueueVideoJob.set(wait: 5.seconds).perform_later(params[:id], "Jason Mraz - I'm Yours (Karaoke Version)", "Nate")
    end
  end
end
