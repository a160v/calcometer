import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="date-range"
export default class extends Controller {
  static targets = ["startDate", "endDate"];

  connect() {
    this.updateEndDateMin();
  }

  updateEndDateMin() {
    if (this.startDateTarget.value) {
      this.endDateTarget.min = this.startDateTarget.value;
    }
  }
}
