import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["search", "map"]

  currentCoords = null;
  selectedPlace = null;

  _placeChanged() {
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

  connect() {
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  validate(event) {
    event.preventDefault();
  }
}
