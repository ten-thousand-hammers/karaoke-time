require "test_helper"

class BrowseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get browse_index_url
    assert_response :success
    assert_select 'h1', text: 'Browse'
    assert_select '#paginator' do
      assert_select 'p', text: "Showing page\n        1\n        of\n        2"
      assert_select 'a', text: "1"
      assert_select 'a[rel=next]', text: "2"
      assert_select 'a[rel=next]', text: "Next ›"
      assert_select 'a[rel=last]', text: "Last »"
    end
  end

  test "should get index with page" do
    get browse_index_url, params: { page: 2 }
    assert_response :success
    assert_select 'h1', text: 'Browse'
    assert_select '#paginator' do
      assert_select 'p', text: "Showing page\n        2\n        of\n        2"
      assert_select 'a', text: "« First"
      assert_select 'a[rel=prev]', text: "‹ Prev"
      assert_select 'a', text: "1"
      assert_select 'a', text: "2"
    end
  end
end
