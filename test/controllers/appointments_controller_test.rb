require 'test_helper'

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @client = Client.create(name: 'Test Client', email: 'test@example.com')
    @patient = Patient.create(
      name: 'John Doe',
      address: '123 Main St',
      client_id: @client.id,
      latitude: 12.34,
      longitude: 56.78
    )
    @user = User.create(
      email: 'user@example.com',
      encrypted_password: 'password',
      name: 'User',
      last_name: 'Example'
    )
    @appointment = Appointment.create(
      start_time: Time.now,
      end_time: Time.now + 1.hour,
      user_id: @user.id,
      patient_id: @patient.id
    )
  end

  test "should get index" do
    get appointments_url
    assert_response :success
  end

  test "should get show" do
    get appointment_url(@appointment)
    assert_response :success
  end
end
