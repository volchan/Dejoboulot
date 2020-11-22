import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["clock", "days", "hours", "minutes", "seconds"];

  interval = null;

  _getTimeRemaining() {
    const endTime = this.data.get("end-time");
    const t = Date.parse(endTime) - Date.parse(new Date());
    const seconds = Math.floor((t / 1000) % 60);
    const minutes = Math.floor((t / 1000 / 60) % 60);
    const hours = Math.floor((t / (1000 * 60 * 60)) % 24);
    const days = Math.floor(t / (1000 * 60 * 60 * 24));
    return {
      total: t,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    };
  }

  _updateClock() {
    const t = this._getTimeRemaining();

    this.daysTarget.innerHTML = t.days;
    this.hoursTarget.innerHTML = ("0" + t.hours).slice(-2);
    this.minutesTarget.innerHTML = ("0" + t.minutes).slice(-2);
    this.secondsTarget.innerHTML = ("0" + t.seconds).slice(-2);

    if (t.total <= 0) {
      clearInterval(interval);
    }
  }

  _initializeClock() {
    this._updateClock();
  }

  connect() {
    this._initializeClock();
    this.interval = setInterval(this._updateClock.bind(this), 1000);
  }
}
