class Performance < ApplicationRecord
  belongs_to :up_next_song, class_name: "Song", optional: true
  belongs_to :now_playing_song, class_name: "Song", optional: true

  def self.instance
    first || create
  end

  after_update_commit -> { 
    if now_playing_song_id_previously_changed?
      broadcast_replace_to "splash", 
        partial: "home/now_playing", 
        locals: { performance: self }, 
        target: "now_playing"

      broadcast_replace_to "splash", 
        partial: "home/video", 
        locals: { performance: self }, 
        target: "video"  
    end

    if up_next_song_id_previously_changed?
      broadcast_replace_to "splash", 
          partial: "home/up_next", 
          locals: { performance: self }, 
          target: "up_next"
    end
  }
end
