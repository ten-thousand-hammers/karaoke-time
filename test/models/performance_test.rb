# == Schema Information
#
# Table name: performances
#
#  id                      :integer          not null, primary key
#  now_playing_url         :string
#  up_next_download_status :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  now_playing_song_id     :integer
#  now_playing_user_id     :integer
#  up_next_song_id         :integer
#  up_next_user_id         :integer
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
require "test_helper"

class PerformanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
