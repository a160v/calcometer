class RecalculateTripJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    # Implement logic here to find associated trips and recalculate their distance and time.
  end
end
