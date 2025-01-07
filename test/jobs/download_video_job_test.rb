require "test_helper"

class DownloadVideoJobTest < ActiveJob::TestCase
  test "it download a video" do
    song = Song.create!(external_id: "123", name: "Test Song")
    Open3.expects(:capture3).with(
      YtDlpManager::BINARY_PATH,
      "-f", "mp4",
      "-o", File.join("public", "videos", "%(id)s.%(ext)s"),
      "https://www.youtube.com/watch?v=#{song.external_id}"
    ).returns(
      [
        "",
        "",
        stub(success?: true)
      ]
    )
    DownloadVideoJob.perform_now(song)
  end

  test "it updates the up next performance status after downloading" do
    song = Song.create!(external_id: "123", name: "Test Song")
    Performance.instance.update!(up_next_song: song, up_next_download_status: "")
    Open3.expects(:capture3).with(
      YtDlpManager::BINARY_PATH,
      "-f", "mp4",
      "-o", File.join("public", "videos", "%(id)s.%(ext)s"),
      "https://www.youtube.com/watch?v=#{song.external_id}"
    ).returns(
      [
        "",
        "",
        stub(success?: true)
      ]
    )
    DownloadVideoJob.perform_now(song)
    assert_equal "completed", Performance.instance.reload.up_next_download_status
  end

  test "it marks a failed download" do
    song = Song.create!(external_id: "123", name: "Test Song")
    Open3.expects(:capture3).with(
      YtDlpManager::BINARY_PATH,
      "-f", "mp4",
      "-o", File.join("public", "videos", "%(id)s.%(ext)s"),
      "https://www.youtube.com/watch?v=#{song.external_id}"
    ).returns(
      [
        "",
        "An error occurred",
        stub(success?: false)
      ]
    )
    DownloadVideoJob.perform_now(song)
    assert_equal "An error occurred", song.reload.download_error
  end

  test "it catches an exception" do
    song = Song.create!(external_id: "123", name: "Test Song")
    Open3.expects(:capture3).with(
      YtDlpManager::BINARY_PATH,
      "-f", "mp4",
      "-o", File.join("public", "videos", "%(id)s.%(ext)s"),
      "https://www.youtube.com/watch?v=#{song.external_id}"
    ).raises("An error occurred")
    DownloadVideoJob.perform_now(song)
    assert_equal "An error occurred", song.reload.download_error
  end

  test "it marks a previously downloaded file as downloaded" do
    song = Song.create!(external_id: "123", name: "Test Song")
    FileUtils.touch(File.join("public", "videos", "#{song.external_id}.mp4"))
    begin
      DownloadVideoJob.perform_now(song)
      assert song.reload.downloaded
    ensure
      FileUtils.rm(File.join("public", "videos", "#{song.external_id}.mp4"))
    end
  end
end
