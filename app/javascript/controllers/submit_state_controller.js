import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit"];

  connect() {
    this.element.addEventListener("turbo:submit-start", () => {
      this.submitTarget.value = "Submitting...";
      this.submitTarget.disabled = true;
    });
  }
}
