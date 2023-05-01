class ClientsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @client = Client.create(name: 'Test Client', email: 'test@example.com')
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get show" do
    get client_url(@client)
    assert_response :success
  end
end
