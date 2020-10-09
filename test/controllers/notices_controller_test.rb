require 'test_helper'

class NoticesControllerTest < ActionDispatch::IntegrationTest
  test "index should redirect when not logged in" do
    get notices_path
    assert_redirected_to login_url
  end

end
