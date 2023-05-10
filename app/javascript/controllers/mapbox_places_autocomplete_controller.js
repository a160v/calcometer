import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

// Connects to data-controller="mapbox-places-autocomplete"
export default class extends Controller {
  static targets = [
    "address",
    "city",
    "streetNumber",
    "route",
    "county",
    "state",
    "postalCode",
    "country",
    "longitude",
    "latitude",
  ];

  connect() {
    console.log("The 'mapbox places autocomplete' controller is connected");
    this.accessToken = "";
    mapboxgl.accessToken = this.accessToken;
  }

  preventSubmit(event) {
    if (event.key === "Enter") {
      event.preventDefault();
    }
  }

  initAutocomplete(event) {
    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      types: "address",
      countries: "ch", // Set to Switzerland
    });

    this.geocoder.on("result", this.placeChanged.bind(this));
    this.geocoder.addTo(`#${this.addressTarget.id}`);
  }

  placeChanged(e) {
    const result = e.result;

    // Mapbox does not separate the street number and route in its results.
    // If you need these separate, you would need to parse the `place_name` or `text` property.
    this.streetNumberTarget.value = "";
    this.routeTarget.value = result.place_name;

    this.cityTarget.value = result.context.find((c) =>
      c.id.startsWith("place")
    ).text;
    this.countyTarget.value = result.context.find((c) =>
      c.id.startsWith("region")
    ).text;
    this.stateTarget.value = result.context.find((c) =>
      c.id.startsWith("region")
    ).text;
    this.postalCodeTarget.value = result.context.find((c) =>
      c.id.startsWith("postcode")
    ).text;
    this.countryTarget.value = result.context.find((c) =>
      c.id.startsWith("country")
    ).text;

    this.longitudeTarget.value = result.geometry.coordinates[0];
    this.latitudeTarget.value = result.geometry.coordinates[1];
  }
}
