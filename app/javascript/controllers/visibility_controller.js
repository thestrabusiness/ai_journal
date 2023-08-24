import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["visibility"];

  toggle() {
    this.visibilityTargets.forEach((target) => {
      if (target.disabled) return;
      target.classList.toggle("hidden");
    });
  }
}
