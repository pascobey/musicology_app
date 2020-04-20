require 'test_helper'

class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get playlists_create_url
    assert_response :success
  end

  test "should get show" do
    get playlists_show_url
    assert_response :success
  end

end
