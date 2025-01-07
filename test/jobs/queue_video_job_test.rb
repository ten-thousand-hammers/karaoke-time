require "test_helper"

class QueueVideoJobTest < ActiveJob::TestCase
  test "it will add a video to be now playing when nothing is playing" do
    song = songs(:jason_mraz_im_yours)
    assert !song.downloaded
    user = users(:nate)

    Performance.instance.update!(
      now_playing_song: nil, now_playing_user: nil,
      up_next_song: nil, up_next_user: nil, up_next_download_status: nil
    )
    mock_yt_download(song, returns: ["", "", stub(success?: true)])

    assert_enqueued_with(job: NextVideoJob) do
      QueueVideoJob.perform_now(song, user, wait: 0)
    end

    assert_equal song, Performance.instance.up_next_song
    assert_equal user, Performance.instance.up_next_user
    assert_equal "completed", Performance.instance.up_next_download_status

    # Moves it to now playing
    perform_enqueued_jobs

    assert_equal song, Performance.instance.now_playing_song
    assert_equal user, Performance.instance.now_playing_user
    assert_nil Performance.instance.up_next_song
    assert_nil Performance.instance.up_next_user
  end

  test "it will add a video to be up next when nothing is playing" do
    song = songs(:jason_mraz_im_yours)
    assert !song.downloaded
    user = users(:nate)

    Performance.instance.update!(
      now_playing_song: songs(:oasis__wonderwall_karaoke_version), now_playing_user: users(:kate),
      up_next_song: nil, up_next_user: nil, up_next_download_status: nil
    )
    mock_yt_download(song, returns: ["", "", stub(success?: true)])

    assert_no_enqueued_jobs(only: NextVideoJob) do
      QueueVideoJob.perform_now(song, user, wait: 0)
    end

    assert_equal song, Performance.instance.up_next_song
    assert_equal user, Performance.instance.up_next_user
    assert_equal "completed", Performance.instance.up_next_download_status
  end

  test "it will add the song to the queue when there is a now playing and up next" do
    song = songs(:jason_mraz_im_yours)
    assert !song.downloaded
    user = users(:nate)

    Performance.instance.update!(
      now_playing_song: songs(:oasis__wonderwall_karaoke_version), now_playing_user: users(:kate),
      up_next_song: songs(:oasis__dont_look_back_in_anger_karaoke_version), up_next_user: users(:nate), up_next_download_status: "completed"
    )
    mock_yt_download(song, returns: ["", "", stub(success?: true)])

    assert_difference "Act.count", 1 do
      assert_no_enqueued_jobs(only: NextVideoJob) do
        QueueVideoJob.perform_now(song, user, wait: 0)
      end
    end

    last_act = Act.last

    assert_equal song, last_act.song
    assert_equal user, last_act.user
  end
end
