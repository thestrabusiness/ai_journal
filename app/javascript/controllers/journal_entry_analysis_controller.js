import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "content"];

  connect() {
    this.buttonTarget.form.addEventListener("turbo:submit-start", () => {
      console.log("turbo:submit-start");
      this.buttonTarget.disabled = true;
      this.contentTarget.innerHTML = "Loading...";
    });
  }
}
