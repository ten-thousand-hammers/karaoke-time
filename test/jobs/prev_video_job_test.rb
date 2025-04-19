require "test_helper"

class PrevVideoJobTest < ActiveJob::TestCase
  test "moves current song to up next and restores last played song" do
    # Setup initial state
    performance = Performance.instance
    performance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    # Create a played act
    played_act = performance.played_acts.create!(
      song: songs(:jason_mraz__im_yours_karaoke_version),
      user: users(:kate),
      played_at: Time.current
    )

    # Run the job
    PrevVideoJob.perform_now

    # Verify the changes
    assert_equal songs(:jason_mraz__im_yours_karaoke_version), performance.reload.now_playing_song
    assert_equal users(:kate), performance.now_playing_user
    assert_equal songs(:oasis__wonderwall_karaoke_version), performance.up_next_song
    assert_equal users(:nate), performance.up_next_user

    # Verify the played act was removed
    assert_nil PlayedAct.find_by(id: played_act.id)
  end

  test "moves up next to acts when going to previous song" do
    performance = Performance.instance
    performance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version),
      up_next_user: users(:kate),
      up_next_song: songs(:jason_mraz__im_yours_karaoke_version)
    )

    # Create a played act
    played_act = performance.played_acts.create!(
      song: songs(:oasis__wonderwall_karaoke_version),
      user: users(:kate),
      played_at: Time.current
    )

    # Run the job
    PrevVideoJob.perform_now

    # Verify the changes
    assert_equal songs(:oasis__wonderwall_karaoke_version), performance.reload.now_playing_song
    assert_equal users(:kate), performance.now_playing_user
    assert_equal songs(:oasis__wonderwall_karaoke_version), performance.up_next_song
    assert_equal users(:nate), performance.up_next_user

    # Verify up_next was moved to acts
    act = performance.acts.last
    assert_equal songs(:jason_mraz__im_yours_karaoke_version), act.song
    assert_equal users(:kate), act.user

    # Verify the played act was removed
    assert_nil PlayedAct.find_by(id: played_act.id)
  end

  test "triggers next video job if no previous song exists" do
    performance = Performance.instance
    performance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    assert_enqueued_with(job: NextVideoJob) do
      PrevVideoJob.perform_now
    end

    # Current song should have moved to up_next
    assert_nil performance.reload.now_playing_song
    assert_nil performance.now_playing_user
    assert_equal songs(:oasis__wonderwall_karaoke_version), performance.up_next_song
    assert_equal users(:nate), performance.up_next_user
  end
end
