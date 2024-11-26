class SongsController < ApplicationController
  def mark_file_problem
    @song = Song.find(params[:id])
    @song.mark_file_problem!
    
    # If this is the currently playing song, we should restart it
    if current_performance&.now_playing_song == @song
      RestartSongJob.perform_later
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def mark_not_embeddable
    @song = Song.find(params[:id])
    @song.update!(not_embeddable: true)

    # If this is the currently playing song, we should restart it
    if current_performance&.now_playing_song == @song
      if current_performance.now_playing_song.downloaded && current_performance.now_playing_song.file_problem
        NextVideoJob.perform_later
      else
        RestartSongJob.perform_later
      end
    end
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
