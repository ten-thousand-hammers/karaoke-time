class RestartSongJob < ApplicationJob
  queue_as :default

  def perform(performance_id = nil)
    performance = performance_id ? Performance.find(performance_id) : Performance.instance
    song = performance.now_playing_song
    
    performance.update(now_playing_song: nil)
    sleep 0.5
    performance.update(now_playing_song: song)
  end
end
