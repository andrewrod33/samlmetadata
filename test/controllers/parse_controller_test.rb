require 'test_helper'

class ParseControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

end
