require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_url
    assert_response :success
  end

  test "can search for a song" do
    SearchController.any_instance.stubs(:ytsearch10).returns(file_fixture("ytsearch10__oasis.json").read)
    get search_url, params: { search: "Oasis" }
    assert_response :success
    assert_select "turbo-frame#results .grid" do
      assert_select "turbo-frame", 10
    end
  end

  test "can play a search that was searched for" do
    SearchController.any_instance.stubs(:ytsearch10).returns(file_fixture("ytsearch10__oasis.json").read)
    get search_url, params: { search: "Oasis" }
    assert_response :success
    song = Song.first

    assert_enqueued_with(job: QueueVideoJob) do
      post play_url, params: { id: song.external_id }
      assert_response :success
    end
  end

  test "can play a search that was searched for with turbo" do
    SearchController.any_instance.stubs(:ytsearch10).returns(file_fixture("ytsearch10__oasis.json").read)
    get search_url, params: { search: "Oasis" }
    assert_response :success
    song = Song.first

    assert_enqueued_with(job: QueueVideoJob) do
      post play_url, params: {
        id: song.external_id
      }, as: :turbo_stream
      assert_response :success
      assert_select "turbo-stream[action=prepend][target=flash]", text: "#{song.name} has been queued"
    end
  end
end
