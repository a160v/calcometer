import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="treatments"
export default class extends Controller {
  static targets = ['treatment', 'totalDistance', 'totalTime'];

  connect() {
    this.updateTotals();
  }

  updateTotals() {
    let totalDistance = 0;
    let totalTime = 0;

    this.treatmentTargets.forEach((treatment) => {
      totalDistance += parseFloat(treatment.dataset.treatmentDistance);
      totalTime += parseFloat(treatment.dataset.treatmentTime);
    });

    this.totalDistanceTarget.textContent = totalDistance.toFixed(2) + ' km';
    this.totalTimeTarget.textContent = totalTime.toFixed(2) + ' minutes';
  }
}
