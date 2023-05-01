import { Controller } from "@hotwired/stimulus";
// import mapboxgl from "mapbox-gl";

// This class connects to a Stimulus controller with the identifier "distance-calculator"
export default class extends Controller {
  connect() {
    console.log("distance calculator controller connected");
  }
  // Define a target element named "distance" in the controller
  static targets = ["distance"];

  // This function is called when the user selects a treatment from the dropdown
  calculateDistance(event) {
    console.log("Function calculateDistance triggered");
    // Retrieve treatment ID and addresses of the selected and previous treatments
    const treatmentId = `/treatments/${treatmentId}`; //"Create treatment"
    console.log("event: ", event);
    console.log("treatmentId: ", treatmentId);
    const treatmentAddress = this.getTreatmentAddress(treatmentId);
    const previousTreatmentAddress =
      this.getPreviousTreatmentAddress(treatmentId);

    // Calculate the distance between the two addresses
    const distance = this.getDistance(
      treatmentAddress,
      previousTreatmentAddress
    );

    // Update the distance target element with the calculated distance
    this.distanceTarget.innerText = distance.toFixed(2) + " km";

    // Update the total distance element with the new accumulated distance
    const totalDistanceElement = document.getElementById("total-distance");
    const currentTotalDistance = parseFloat(totalDistanceElement.textContent);
    totalDistanceElement.textContent = (
      currentTotalDistance + distance
    ).toFixed(2);
  }

  // Fetch the address of the selected treatment
  getTreatmentAddress(treatmentId) {
    console.log("Function TreatmentAddress triggered");
    const response = fetch(`/treatments/${treatmentId}/address`);
    console.log("response: ", response);
    return response.text();
  }

  // Fetch the address of the previous treatment in the list
  getPreviousTreatmentAddress(treatmentId) {
    console.log("Function PreviousTreatmentAddress triggered");
    const response = fetch(`/treatments/${treatmentId}/previous_address`);
    return response.text();
  }

  // Calculate the distance between two addresses using Mapbox API
  getDistance(address1, address2) {
    console.log("Function Distance triggered");
    const accessToken =
      "pk.eyJ1Ijoic3RhcmxvcmQ4IiwiYSI6ImNsaDI3N3hxaTFiOXAzZHJ6ZnRkNmluYzkifQ.FzHRAgrgziHw63tCk5aKeg";
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving/${encodeURIComponent(
      address1
    )};${encodeURIComponent(
      address2
    )}?access_token=${accessToken}&geometries=geojson`;
    const response = fetch(url);
    const json = response.json();
    const distance = json.routes[0].distance / 1000;
    return distance;
  }
}
