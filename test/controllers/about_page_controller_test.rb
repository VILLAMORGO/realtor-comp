require "test_helper"

class AboutPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get about_page_index_url
    assert_response :success
  end
end
