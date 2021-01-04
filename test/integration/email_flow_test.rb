require "test_helper"

class EmailFlowTest < ActionDispatch::IntegrationTest
  setup do
    @email = emails :valid
    @token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VyX3JvbGUiOiJ1c2VyIn0.quOrWPCjOcaMtzHfoISv4b2v-XhOn03_80MFo3dBfxU'
  end

  test "listing the emails" do
    get "/api/v1/emails/index"
    assert_response :success
  end

  test "creating an email" do
    post "/api/v1/emails", params: { email: @email.email}, headers: {
      Authorization:  @token
  }
    assert_response :success
  end
end
