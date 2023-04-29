import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

// Connects to data-controller="time-calculator"
export default class extends Controller {
  static targets = ["time"];

  async calculateTime(event) {
    const patientId = event.target.value;
    const patientAddress = await this.getPatientAddress(patientId);
    const nextPatientAddress = await this.getNextPatientAddress(patientId);

    const time = await this.getDrivingTime(patientAddress, nextPatientAddress);
    this.timeTarget.innerText = time.toFixed(2) + " minutes";
    // Update the total time element
    const totalTimeElement = document.getElementById("total-time");
    const currentTotalTime = parseFloat(totalTimeElement.textContent);
    totalTimeElement.textContent = (currentTotalTime + time).toFixed(2);
  }

  async getPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/address`);
    return await response.text();
  }

  async getNextPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/next_patient_address`);
    return await response.text();
  }

  async getDrivingTime(address1, address2) {
    const accessToken = process.env.MAPBOX_API_KEY;
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
