class PrevVideoJob < ApplicationJob
  queue_as :default

  def perform
    performance = Performance.instance

    last_played = performance.played_acts.first

    # Move up_next to acts if exists
    if performance.up_next_song.present?
      performance.acts.create!(
        song: performance.up_next_song,
        user: performance.up_next_user
      )
    end

    # Move current song to up_next if exists
    if performance.now_playing_song.present?
      performance.up_next_song = performance.now_playing_song
      performance.up_next_user = performance.now_playing_user
    end

    # Set previous song as now playing
    performance.now_playing_song = last_played&.song
    performance.now_playing_user = last_played&.user

    # Remove the last played record since we're moving it back to now playing
    last_played.destroy if last_played.present?
    performance.save!

    if performance.now_playing_song.blank?
      NextVideoJob.perform_later
    end
  end
end
