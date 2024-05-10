class Performance < ApplicationRecord
  belongs_to :up_next_song, class_name: "Song", optional: true
  belongs_to :up_next_user, class_name: "User", optional: true
  belongs_to :now_playing_song, class_name: "Song", optional: true
  belongs_to :now_playing_user, class_name: "User", optional: true

  def self.instance
    first || create
  end

  after_update_commit -> { 
    if now_playing_song_id_previously_changed?
      broadcast_replace_to "splash", 
        partial: "splash/now_playing", 
        locals: { performance: self }, 
        target: "now_playing"

      broadcast_replace_to "home", 
        partial: "home/now_playing", 
        locals: { performance: self }, 
        target: "now_playing"

      broadcast_replace_to "splash", 
        partial: "splash/video", 
        locals: { performance: self }, 
        target: "video"  
    end

    if up_next_song_id_previously_changed?
      broadcast_replace_to "splash", 
          partial: "splash/up_next", 
          locals: { performance: self }, 
          target: "up_next"

      broadcast_replace_to "home", 
        partial: "home/up_next", 
        locals: { performance: self }, 
        target: "up_next"
    end
  }
end
