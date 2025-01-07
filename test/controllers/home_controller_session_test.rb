require "test_helper"

class HomeControllerSessionTest < ActionDispatch::IntegrationTest
  test "is not logged in by default" do
    get root_url
    assert_response :success
    assert_select "footer" do
      assert_select "a i.fa-solid.fa-house-user"
      assert_select "a i.fa-solid.fa-music"
      assert_select "a i.fa-solid.fa-magnifying-glass"
      assert_select "a i.fa-solid.fa-gear"
      assert_select "a i.fa-regular.fa-face-smile", count: 0
    end
  end

  test "can be logged in with an id in _karaoke_time_browser_id" do
    user = users(:nate)
    cookies[:_karaoke_time_browser_id] = user.browser_id
    get root_url
    assert_response :success
    assert_select "footer" do
      assert_select "a i.fa-regular.fa-face-smile"
    end
  end

  test "can be logged in with json in _karaoke_time_browser_id" do
    user = users(:nate)
    cookies[:_karaoke_time_browser_id] = JSON.dump({
      version: 1,
      id: user.browser_id
    })
    get root_url
    assert_response :success
    assert_select "footer" do
      assert_select "a i.fa-regular.fa-face-smile"
    end
  end

  test "it will create a user if one doesn't exist" do
    browser_id = SecureRandom.uuid
    cookies[:_karaoke_time_browser_id] = JSON.dump({
      version: 1,
      id: browser_id
    })

    assert_difference "User.count" do
      get search_url
    end

    assert_response :redirect

    user = User.find_by(browser_id: browser_id)
    assert_not_nil user

    assert_redirected_to edit_profile_url(user)
  end
end
