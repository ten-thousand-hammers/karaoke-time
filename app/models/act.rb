class Act < ApplicationRecord
  belongs_to :song
  belongs_to :user
  belongs_to :performance

  after_create_commit -> { 
    broadcast_replace_to "home", 
      partial: "home/queue", 
      locals: { performance: self.performance }, 
      target: "queue"
  }

  after_destroy_commit -> {
    broadcast_replace_to "home", 
      partial: "home/queue", 
      locals: { performance: self.performance }, 
      target: "queue"
  }
end
