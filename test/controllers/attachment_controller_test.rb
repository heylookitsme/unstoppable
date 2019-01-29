require 'test_helper'

class AttachmentControllerTest < ActionDispatch::IntegrationTest
  test "should get photo" do
    get attachment_photo_url
    assert_response :success
  end

end
