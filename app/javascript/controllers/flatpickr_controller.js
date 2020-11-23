// import stimulus-flatpickr wrapper controller to extend it
import Flatpickr from "stimulus-flatpickr";

// you can also import a translation file
import { French } from "flatpickr/dist/l10n/fr.js";

// import a theme (could be in your main CSS entry too...)
import "flatpickr/dist/flatpickr.css";

// create a new Stimulus controller by extending stimulus-flatpickr wrapper controller
export default class extends Flatpickr {
  connect() {
    super.connect();
    console.log(this.config);
  }

  initialize() {
    // sets your language (you can also set some global setting for all time pickers)
    super.initialize();

    this.config = {
      ...this.config,
      locale: French,
      enableTime: true,
      time_24hr: true,
    };
  }

  // all flatpickr hooks are available as callbacks in your Stimulus controller
  change(selectedDates, dateStr, instance) {
    console.log("the callback returns the selected dates", selectedDates);
    console.log("but returns it also as a string", dateStr);
    console.log("and the flatpickr instance", instance);
  }
}
