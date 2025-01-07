require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    sign_in users(:nate)
    get edit_profile_url(users(:nate).id)
    assert_response :success
  end

  test "should update nickname" do
    sign_in users(:nate)
    patch profile_url(users(:nate).id), params: {user: {nickname: "Nate the Great"}}
    assert_response :redirect
    assert_equal "Nate the Great", users(:nate).reload.nickname
  end

  test "nickname cannot be longer than 20 characters" do
    sign_in users(:nate)
    patch profile_url(users(:nate).id), params: {user: {nickname: "Nate the Great and Powerful"}}
    assert_response :success
    assert_equal "Nate", users(:nate).reload.nickname
  end
end
