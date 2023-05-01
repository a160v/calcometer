import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

// This class connects to a Stimulus controller with the identifier "time-calculator"
export default class extends Controller {
  // Define a target element named "time" in the controller
  static targets = ["time"];

  // This async function is called when the user selects a patient from the dropdown
  async calculateTime(event) {
    // Retrieve patient ID and addresses of the selected and next patients
    const patientId = event.target.value;
    const patientAddress = await this.getPatientAddress(patientId);
    const nextPatientAddress = await this.getNextPatientAddress(patientId);

    // Calculate the driving time between the two addresses
    const time = await this.getDrivingTime(patientAddress, nextPatientAddress);

    // Update the time target element with the calculated time
    this.timeTarget.innerText = time.toFixed(2) + " minutes";

    // Update the total time element with the new accumulated time
    const totalTimeElement = document.getElementById("total-time");
    const currentTotalTime = parseFloat(totalTimeElement.textContent);
    totalTimeElement.textContent = (currentTotalTime + time).toFixed(2);
  }

  // Fetch the address of the selected patient
  async getPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/address`);
    return await response.text();
  }

  // Fetch the address of the next patient in the list
  async getNextPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/next_patient_address`);
    return await response.text();
  }

  // Calculate the driving time between two addresses using Mapbox API
  async getDrivingTime(address1, address2) {
    const accessToken =
      "pk.eyJ1Ijoic3RhcmxvcmQ4IiwiYSI6ImNsaDI3N3hxaTFiOXAzZHJ6ZnRkNmluYzkifQ.FzHRAgrgziHw63tCk5aKeg";
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${encodeURIComponent(
      address1
    )};${encodeURIComponent(
      address2
    )}?access_token=${accessToken}&geometries=geojson`;

    const response = await fetch(url);
    const json = await response.json();
    const time = json.routes[0].duration / 60;
    return time;
  }
}
