require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @tenant = Tenant.create(name: 'Test tenant', email: 'test@example.com')
    @patient = Patient.create(
      name: 'John Doe',
      address: '123 Main St',
      tenant_id: @tenant.id,
      latitude: 12.34,
      longitude: 56.78
    )
  end

  test "should get index" do
    get patients_url
    assert_response :success
  end

  test "should get show" do
    get patient_url(@patient)
    assert_response :success
  end
end
