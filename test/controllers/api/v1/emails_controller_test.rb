require "test_helper"

class Api::V1::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email = emails :valid
    @token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VyX3JvbGUiOiJ1c2VyIn0.quOrWPCjOcaMtzHfoISv4b2v-XhOn03_80MFo3dBfxU'
  end

  test "should get index" do
    get "/api/v1/emails/index"
    assert_response :success
  end

  test "should create email" do
    post "/api/v1/emails", params: { email: @email.email}, headers: {
      Authorization: @token
  }
    assert_response :success
  end

  test "get response" do
    get "/api/v1/emails/index"
    assert_equal 200, response.status
  end

  test "create response" do
    post "/api/v1/emails", params: { email: @email.email}, headers: {
      Authorization:  @token
  }
    assert_equal 200, response.status
  end
end
