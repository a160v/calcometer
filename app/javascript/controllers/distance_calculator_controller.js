import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

// Connects to data-controller="distance-calculator"
export default class extends Controller {
  static targets = ["distance"];

  async calculateDistance(event) {
    const patientId = event.target.value;
    const patientAddress = await this.getPatientAddress(patientId);
    const nextPatientAddress = await this.getNextPatientAddress(patientId);

    const distance = await this.getDistance(patientAddress, nextPatientAddress);
    this.distanceTarget.innerText = distance.toFixed(2) + " km";

    // Update the total distance element
    const totalDistanceElement = document.getElementById("total-distance");
    const currentTotalDistance = parseFloat(totalDistanceElement.textContent);
    totalDistanceElement.textContent = (
      currentTotalDistance + distance
    ).toFixed(2);
  }

  async getPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/address`);
    return await response.text();
  }

  async getNextPatientAddress(patientId) {
    const response = await fetch(`/patients/${patientId}/next_patient_address`);
    return await response.text();
  }

  async getDistance(address1, address2) {
    const accessToken = process.env.MAPBOX_API_KEY;
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${encodeURIComponent(
      address1
    )};${encodeURIComponent(
      address2
    )}?access_token=${accessToken}&geometries=geojson`;

    const response = await fetch(url);
    const json = await response.json();
    const distance = json.routes[0].distance / 1000;
    return distance;
  }
}
