import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="treatment-form"
export default class extends Controller {
  static targets = ["startTime", "endTime"];

  connect() {
    this.startTimeTarget.addEventListener(
      "change",
      this.updateEndTime.bind(this)
    );
  }

  updateEndTime() {
    if (this.startTimeTarget.value >= this.endTimeTarget.value) {
      const newEndTime = new Date(
        new Date().setHours(this.startTimeTarget.valueAsDate.getHours() + 1)
      );
      this.endTimeTarget.valueAsDate = newEndTime;
      this.endTimeTarget.min = this.startTimeTarget.value;
    }
  }
}
