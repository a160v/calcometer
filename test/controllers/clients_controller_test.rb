class TenantControllerTest < ActionDispatch::IntegrationTest
  def setup
    @tenant = Tenant.create(name: 'Test tenant', email: 'test@example.com')
  end

  test "should get index" do
    get tenants_url
    assert_response :success
  end

  test "should get show" do
    get tenant_url(@tenant)
    assert_response :success
  end
end
