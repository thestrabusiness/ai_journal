import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit", "required"];

  checkRequired() {
    this.requiredTargets.forEach((target) => {
      if (!target.value || target.value === "") {
        this.submitTarget.disabled = true;
      } else {
        this.submitTarget.disabled = false;
      }
    });
  }

  submit(event) {
    event.preventDefault();
    if (this.submitTarget.disabled) return;

    this.submitTarget.value = "Submitting...";
    this.submitTarget.disabled = true;
    this.element.requestSubmit();
  }
}
