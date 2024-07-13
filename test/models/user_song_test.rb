# == Schema Information
#
# Table name: user_songs
#
#  id         :integer          not null, primary key
#  plays      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  song_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_songs_on_song_id  (song_id)
#  index_user_songs_on_user_id  (user_id)
#
# Foreign Keys
#
#  song_id  (song_id => songs.id)
#  user_id  (user_id => users.id)
#
require "test_helper"

class UserSongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
