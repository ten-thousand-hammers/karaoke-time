require "test_helper"

class RestartSongJobTest < ActiveJob::TestCase
  test "it restart a song" do
    song = songs(:jason_mraz_im_yours)
    performance = Performance.instance
    performance.update(now_playing_song: song)
    Performance.any_instance.expects(:update).with(now_playing_song: nil)
    Performance.any_instance.expects(:update).with(now_playing_song: song)
    RestartSongJob.perform_now
  end
end
