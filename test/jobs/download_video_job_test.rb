require "test_helper"

class DownloadVideoJobTest < ActiveJob::TestCase
  test "it download a video" do
    song = songs(:jason_mraz_im_yours)
    DownloadVideoJob.perform_now(song)
  end
end
