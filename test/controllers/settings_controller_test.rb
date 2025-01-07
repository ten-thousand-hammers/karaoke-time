require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_url
    assert_response :success
  end

  test "should update settings" do
    sign_in users(:nate)
    assert !Setting.always_embed
    patch settings_url, params: { always_embed: "1" }
    assert_response :redirect
    assert Setting.always_embed
  end

  test "should update ytdlp" do
    sign_in users(:nate)
    YtDlpManager.expects(:update_binary).returns({ success: true, message: "Updated successfully" })
    post settings_update_yt_dlp_url
    assert_response :success
  end
end
