import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calculate-total-distance-and-duration"
export default class extends Controller {
  connect() {
    console.log("The 'distance and duration calculator' controller is connected");
  }

  calculate() {
    let locale = window.location.pathname.split('/')[1];

    fetch(`/${locale}/appointments/calculate_daily_driving_distance_and_duration_from_service`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
      }
    })
    .then(response => response.json())
    .then(data => {
      // Update the total distance and duration in your view
      document.querySelector("#daily_distance").textContent = data.daily_distance;
      document.querySelector("#daily_duration").textContent = data.daily_duration;
      })
    .catch(error => console.error('Error:', error));
  }

}
