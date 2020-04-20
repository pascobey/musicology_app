require 'test_helper'

class StatusControllerTest < ActionDispatch::IntegrationTest
  test "should get finished" do
    get status_finished_url
    assert_response :success
  end

  test "should get finish_build" do
    get status_finish_build_url
    assert_response :success
  end

  test "should get update_build" do
    get status_update_build_url
    assert_response :success
  end

end
