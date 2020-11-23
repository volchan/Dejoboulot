import Rails from "@rails/ujs";
import { Controller } from "stimulus";
export default class extends Controller {
  static targets = ["search", "map", "list", "btn"]

  currentCoords = null;
  selectedPlace = null;

  _placeChanged() {
    this._enableBtn();
    const place = this.autocomplete.getPlace()

    if (!place.geometry) {
      window.alert(`No details available for input: ${place.name}`)
      return
    }

    this.selectedPlace = place;

    if (place.geometry.viewport) {
      this.map.fitBounds(place.geometry.viewport)
    } else {
      this.map.setCenter(place.geometry.location)
      this.map.setZoom(20)
    }

    this.marker.setPosition(place.geometry.location)
    this.marker.setVisible(true)
  }

  _success({coords}) {
    const { latitude, longitude } = coords;

    this.currentCoords = [latitude, longitude];
  }

  _error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }

  _getCurrentLocation() {
    navigator.geolocation.getCurrentPosition(this._success.bind(this), this._error.bind(this));
    return this.currentCoords || [46.227638, 2.213749];
  }

  initMap() {
    this.map = new google.maps.Map(this.mapTarget, {
      center: new google.maps.LatLng(...this._getCurrentLocation()),
      zoom: 5
    })

    this.autocomplete = new google.maps.places.Autocomplete(this.searchTarget)
    this.autocomplete.bindTo('bounds', this.map)
    this.autocomplete.setFields(['address_components', 'geometry', 'icon', 'name'])
    this.autocomplete.addListener('place_changed', this._placeChanged.bind(this))

    this.marker = new google.maps.Marker({
      map: this.map,
      anchorPoint: new google.maps.Point(0, -29)
    })
  }

  keydown(event) {
    if (event.key == "Enter") {
      event.preventDefault()
    }
  }

  _enableBtn() {
    this.btnTarget.disabled = false;
  }

  _disableBtn() {
    this.btnTarget.disabled = true;
  }

  connect() {
    this._disableBtn();
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  _buildAddress(components) {
    return components.map(({long_name}) => long_name).join(' ');
  };

  _formatFormData() {
    const { name, address_components, geometry: { location: { lat, lng } } } = this.selectedPlace;
    const address = this._buildAddress(address_components);
    const countryElement = address_components.find((el) => el.types.includes("country"));

    const data = {
      name,
      address,
      country: countryElement.long_name,
      lat: lat(),
      long: lng(),
    };

    const formData = new FormData();
    for (let key in data) {
      formData.append(`place[${key}]`, data[key]);
    }
    formData.append(`poll[slug]`, this.data.get("poll-slug"));

    return formData;
  }

  _resetSearchInput() {
    this.searchTarget.value = null;
  }

  _appendProposal(data) {
    this._resetSearchInput();
    this._disableBtn();
    this.listTarget.insertAdjacentHTML(
      "beforeEnd",
      data.querySelector("body").innerHTML,
    );
  }

  validate(event) {
    event.preventDefault();
    
    Rails.ajax({
      url: this.data.get("create-url"),
      type: "POST",
      data: this._formatFormData(),
      success: this._appendProposal.bind(this),
    });
  }
}
