import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="date-range"
export default class extends Controller {
  connect() {
    console.log("The 'date range' controller is connected");
  }
  static targets = ["startDate", "endDate"];

  updateEndDateMin() {
    if (this.startDateTarget.value) {
      this.endDateTarget.min = this.startDateTarget.value;
    }
  }
}
