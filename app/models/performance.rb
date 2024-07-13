# == Schema Information
#
# Table name: performances
#
#  id                  :integer          not null, primary key
#  now_playing_url     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  now_playing_song_id :integer
#  now_playing_user_id :integer
#  up_next_song_id     :integer
#  up_next_user_id     :integer
#
# Indexes
#
#  index_performances_on_now_playing_song_id  (now_playing_song_id)
#  index_performances_on_now_playing_user_id  (now_playing_user_id)
#  index_performances_on_up_next_song_id      (up_next_song_id)
#  index_performances_on_up_next_user_id      (up_next_user_id)
#
# Foreign Keys
#
#  now_playing_song_id  (now_playing_song_id => songs.id)
#  now_playing_user_id  (now_playing_user_id => users.id)
#  up_next_song_id      (up_next_song_id => songs.id)
#  up_next_user_id      (up_next_user_id => users.id)
#
class Performance < ApplicationRecord
  belongs_to :up_next_song, class_name: "Song", optional: true
  belongs_to :up_next_user, class_name: "User", optional: true
  belongs_to :now_playing_song, class_name: "Song", optional: true
  belongs_to :now_playing_user, class_name: "User", optional: true
  has_many :acts

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
