require "application_system_test_case"

class SplashTest < ApplicationSystemTestCase
  test "can visit the splash page" do
    visit splash_url
    assert_selector "#splash" do
      assert_selector "#bottom-container"
      assert_selector "#permissions"
    end
  end

  test "it shows the qr code" do
    visit splash_url
    assert_selector "#splash" do
      assert_selector "#bottom-container"
      assert_selector "#permissions" do
        assert_selector "img[alt='QR code']"
      end
    end
  end

  test "can manually confirm permissions dialog" do
    visit splash_url
    assert_selector "#splash" do
      assert_selector "#bottom-container"
      assert_selector "#permissions" do
        click_on "Confirm"
      end
    end
  end

  test "can queue a song" do
    visit splash_url
    click_on "Confirm"
    current_user = users(:nate)
    song = songs(:oasis__wonderwall_karaoke_version)
    FileUtils.cp Rails.root.join("test", "fixtures", "files", "sample.mp4"), Rails.root.join("public", "videos", "#{song.external_id}.mp4")
    begin
      QueueVideoJob.perform_now(song, current_user)
      wait_for_turbo_frame "#up-next"
      assert_selector "#up-next" do
        assert_selector "h2", text: "Up Next"
        assert_selector "h3", text: song.name
        assert_selector "h4", text: current_user.nickname
      end
    ensure
      File.delete(Rails.root.join("public", "videos", "#{song.external_id}.mp4"))
    end
  end

  test "can play a song" do
    visit splash_url
    click_on "Confirm"
    current_user = users(:nate)
    current_user.update!(avatar: 1)
    song = songs(:oasis__wonderwall_karaoke_version)
    FileUtils.cp Rails.root.join("test", "fixtures", "files", "sample.mp4"), Rails.root.join("public", "videos", "#{song.external_id}.mp4")
    begin
      QueueVideoJob.perform_now(song, current_user, wait: 0)
      wait_for_turbo_frame "#video"
      assert_selector "#video" do
        assert_selector "video[autoplay]"
      end
      assert_selector "#now-playing" do
        assert_selector "h2", text: song.name
        assert_selector "h3", text: current_user.nickname
        assert_selector "img[src='/images/avatars/avatar_1.png']"
      end
    ensure
      File.delete(Rails.root.join("public", "videos", "#{song.external_id}.mp4"))
    end
  end

  test "can skip a song" do
    visit splash_url
    click_on "Confirm"
    current_user = users(:nate)
    song = songs(:oasis__wonderwall_karaoke_version)
    FileUtils.cp Rails.root.join("test", "fixtures", "files", "sample.mp4"), Rails.root.join("public", "videos", "#{song.external_id}.mp4")
    begin
      QueueVideoJob.perform_now(song, current_user, wait: 0)
      wait_for_turbo_frame "#video"
      assert_selector "#video"
      NextVideoJob.perform_now(wait: 0)
      assert_selector "#video", visible: false
    ensure
      File.delete(Rails.root.join("public", "videos", "#{song.external_id}.mp4"))
    end
  end

  test "it shows who is up next" do
    visit splash_url
    click_on "Confirm"
    current_user = users(:nate)
    song = songs(:oasis__wonderwall_karaoke_version)
    FileUtils.cp Rails.root.join("test", "fixtures", "files", "sample.mp4"), Rails.root.join("public", "videos", "#{song.external_id}.mp4")
    begin
      QueueVideoJob.perform_now(song, current_user, wait: 0)
      wait_for_turbo_frame "#video"
      assert_selector "#video"
      QueueVideoJob.perform_now(songs(:oasis__wonderwall_karaoke_version), users(:kate))
      wait_for_turbo_frame "#up_next"
      assert_selector "#up_next" do
        assert_selector "h2", text: "Up next"
        assert_selector "h3", text: songs(:oasis__wonderwall_karaoke_version).name
        assert_selector "h4", text: users(:kate).nickname
      end
    ensure
      File.delete(Rails.root.join("public", "videos", "#{song.external_id}.mp4"))
    end
  end
end
