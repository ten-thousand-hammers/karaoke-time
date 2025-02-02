# == Schema Information
#
# Table name: acts
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  performance_id :integer
#  song_id        :integer          not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_acts_on_performance_id  (performance_id)
#  index_acts_on_song_id         (song_id)
#  index_acts_on_user_id         (user_id)
#
# Foreign Keys
#
#  performance_id  (performance_id => performances.id)
#  song_id         (song_id => songs.id)
#  user_id         (user_id => users.id)
#
class Act < ApplicationRecord
  belongs_to :song
  belongs_to :user
  belongs_to :performance

  after_create_commit -> {
    broadcast_replace_to "home",
      partial: "home/queue",
      locals: {performance: performance},
      target: "queue"
  }

  after_destroy_commit -> {
    broadcast_replace_to "home",
      partial: "home/queue",
      locals: {performance: performance},
      target: "queue"
  }
end
