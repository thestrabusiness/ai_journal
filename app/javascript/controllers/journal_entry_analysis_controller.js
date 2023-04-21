import { Controller } from "@hotwired/stimulus";
import feather from "feather-icons";

export default class extends Controller {
  static targets = ["button", "content"];

  connect() {
    feather.replace();

    this.buttonTarget.form.addEventListener("turbo:submit-start", () => {
      console.log("turbo:submit-start");
      this.buttonTarget.disabled = true;
      this.contentTarget.innerHTML = "Loading...";
    });
  }
}
