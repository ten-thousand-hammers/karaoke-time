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

  def destroy
    @song = Song.find(params[:id])

    # Delete the file from disk if it exists
    if @song.downloaded? && @song.path.present?
      file_path = Rails.root.join("public", @song.path)
      File.delete(file_path) if File.exist?(file_path)
    end

    # Skip the song if it is currently playing
    if Performance.instance.now_playing_song == @song
      NextVideoJob.perform_now
    end

    # Skip the song if it is in the up next queue
    if Performance.instance.up_next_song == @song
      SkipUpNextJob.perform_now
    end

    # Remove from database
    @song.user_songs.destroy_all
    @song.acts.destroy_all
    @song.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: "Song was successfully deleted.") }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@song) }
    end
  end
end
