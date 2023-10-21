import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="calculate-distance-and-duration"
export default class extends Controller {
  connect() {
    console.log("The 'distance and duration calculator' controller is connected");
  }

  async calculate() {
    const locale = window.location.pathname.split('/')[1]
    const url = `/${locale}/appointments/calculate_distance_and_duration`
    const response = await post(url)

    if (response.ok) {
      const data = await response.json

      // Update the total distance and duration in your view
      document.querySelector("#driving_distance").textContent = `${data.driving_distance} km`;
      document.querySelector("#driving_duration").textContent = `${data.driving_duration} min`;
    } else {
      console.error("Couldn't update the driving distance and duration")
    }
  }
}
