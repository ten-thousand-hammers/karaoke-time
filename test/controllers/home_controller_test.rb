require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get root_url
    assert_response :success
    assert_select 'h2', text: 'Now Playing'
    assert_select 'h2', text: 'Next Song'
    assert_select 'h2', text: 'Queue'
  end

  test "can render qrcode" do
    get qrcode_url
    assert_response :success
  end

  test "can skip the active song" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version)
    )

    assert_enqueued_with(job: NextVideoJob) do
      post skip_url
      assert_response :no_content
    end

    perform_enqueued_jobs

    assert_nil Performance.instance.now_playing_user
    assert_nil Performance.instance.now_playing_song
  end

  test "can skip the up next song" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version),

      up_next_user: users(:kate),
      up_next_song: songs(:jason_mraz__im_yours_karaoke_version)
    )

    assert_enqueued_with(job: SkipUpNextJob) do
      post skip_url, params: { up_next: true }
      assert_response :no_content
    end

    perform_enqueued_jobs

    assert_not_nil Performance.instance.now_playing_user
    assert_not_nil Performance.instance.now_playing_song
    assert_nil Performance.instance.up_next_user
    assert_nil Performance.instance.up_next_song
  end

  test "can skip a specific song" do
    Performance.instance.update!(
      now_playing_user: users(:nate),
      now_playing_song: songs(:oasis__wonderwall_karaoke_version),

      up_next_user: users(:kate),
      up_next_song: songs(:jason_mraz__im_yours_karaoke_version)
    )

    act = Act.create!(
      performance: Performance.instance,
      user: users(:nate),
      song: songs(:green_day__basket_case_karaoke_version)
    )

    assert_enqueued_with(job: SkipActJob) do
      post skip_url, params: { act_id: act.id }
      assert_response :no_content
    end

    perform_enqueued_jobs

    assert_not_nil Performance.instance.now_playing_user
    assert_not_nil Performance.instance.now_playing_song
    assert_not_nil Performance.instance.up_next_user
    assert_not_nil Performance.instance.up_next_song

    assert_nil Act.find_by(id: act.id)
  end
end
