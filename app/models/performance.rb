class Performance < ApplicationRecord
  def self.instance
    first || create
  end

  after_update_commit -> { 
    broadcast_replace_to "splash", 
      partial: "home/now_playing", 
      locals: { performance: self }, 
      target: "now_playing"

    broadcast_replace_to "splash", 
      partial: "home/up_next", 
      locals: { performance: self }, 
      target: "up_next"

    broadcast_replace_to "splash", 
      partial: "home/video", 
      locals: { performance: self }, 
      target: "video"
  }
end
