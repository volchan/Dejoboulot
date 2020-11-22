import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['source', 'btn'];

  defaultText = "";

  connect() {
    this.defaultText = this.btnTarget.innerText;
  }

  _resetBtnText() {
    this.btnTarget.innerText = this.defaultText;
  }

  _notifyCopied() {
    this.btnTarget.innerText = this.data.get("copied-text");
    setTimeout(this._resetBtnText.bind(this), 1000);
  }

  copy(event) {
    event.preventDefault();
    this.sourceTarget.select();
    document.execCommand("copy");
    this._notifyCopied();
  }
}
