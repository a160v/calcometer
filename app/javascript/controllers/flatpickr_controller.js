import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  connect() {
    new flatpickr(this.element, {
      mode: "range",
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
      onChange: this.handleChange.bind(this),
    });
  }
}
