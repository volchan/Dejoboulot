import Rails from "@rails/ujs";
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form", "addFieldBtn", "removeFieldBtn", "input", "hiddenField", "template"];

  defaultInput = null;
  emails = [];

  connect() {
    this.defaultInput = this.templateTarget.innerHTML;
  }

  removeField(event) {
    event.preventDefault();
    event.target.closest(".input-group").remove();
  }

  addField(event) {
    event.preventDefault();
    this.addFieldBtnTarget.insertAdjacentHTML("beforeBegin", this.defaultInput);
  }

  submit(event) {
    event.preventDefault();
    this.hiddenFieldTarget.value = this.inputTargets
      .map((el) => el.value)
      .join(";");
    this.formTarget.submit();
  }
}
