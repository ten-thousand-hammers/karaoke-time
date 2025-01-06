require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  test "can mark file problem" do
    post mark_file_problem_song_url(songs(:jason_mraz_im_yours))
    assert_response :redirect

    assert_equal true, songs(:jason_mraz_im_yours).reload.file_problem
  end

  test "marking file problem will restart the song if it is currently playing" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    assert_enqueued_with(job: RestartSongJob) do
      post mark_file_problem_song_url(songs(:oasis__wonderwall_karaoke_version))
      assert_response :redirect
    end
  end

  test "it will mark the song as not embeddable" do
    post mark_not_embeddable_song_url(songs(:jason_mraz_im_yours))
    assert_response :redirect

    assert_equal true, songs(:jason_mraz_im_yours).reload.not_embeddable
  end

  test "marking not embeddable will restart the song if it is currently playing" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    assert_enqueued_with(job: RestartSongJob) do
      post mark_not_embeddable_song_url(songs(:oasis__wonderwall_karaoke_version))
      assert_response :redirect
    end
  end

  test "marking not embeddable will queue the next video if the song is downloaded and there is a file problem" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    songs(:oasis__wonderwall_karaoke_version).update!(downloaded: true, file_problem: true)

    assert_enqueued_with(job: NextVideoJob) do
      post mark_not_embeddable_song_url(songs(:oasis__wonderwall_karaoke_version))
      assert_response :redirect
    end
  end

  test "it will destroy the song" do
    delete song_url(songs(:jason_mraz_im_yours))
    assert_response :redirect

    assert_nil Song.find_by(id: songs(:jason_mraz_im_yours).id)
  end

  test "when deleting a song, it will remove the file if it was downloaded" do
    FileUtils.cp Rails.root.join("test", "fixtures", "files", "sample.mp4"), Rails.root.join("public", "videos", "jason_mraz_im_yours.mp4")
    song = songs(:jason_mraz_im_yours)
    song.update!(
      downloaded: true,
      path: "videos/jason_mraz_im_yours.mp4"
    )

    assert File.exist?(Rails.root.join("public", song.path))

    delete song_url(song)
    assert_response :redirect

    assert_nil Song.find_by(id: song.id)
    assert_not File.exist?(Rails.root.join("public", song.path))
  end

  test "when deleting a song, it will skip the up next song if it is the song being deleted" do
    song = songs(:jason_mraz_im_yours)

    Performance.instance.update!(
      up_next_user: users(:nate),
      up_next_song: song
    )

    delete song_url(song)
    assert_response :redirect

    assert_nil Performance.instance.up_next_user
    assert_nil Performance.instance.up_next_song
  end

  test "when deleting a song, it will skip the song if it is currently playing" do
    song = songs(:jason_mraz_im_yours)

    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: song
    )

    delete song_url(song)
    assert_response :redirect

    assert_nil Performance.instance.now_playing_user
    assert_nil Performance.instance.now_playing_song
  end
end
