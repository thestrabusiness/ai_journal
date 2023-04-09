import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "content"];

  connect() {
    this.isOpen = false;
    this.handleToggleMenu = this.toggleMenu.bind(this);
    this.addEventListeners();
    document.addEventListener("turbo:load", () => {
      this.addEventListeners();
    });
  }

  addEventListeners() {
    this.buttonTarget.addEventListener("click", this.handleToggleMenu);
  }

  toggleMenu() {
    if (this.isOpen) {
      this.closeModal();
      this.isOpen = false;
    } else {
      this.openModal();
      this.isOpen = true;
    }
  }

  disconnect() {
    this.buttonTarget.removeEventListener("click", this.handleToggleMenu);
    document.removeEventListener("turbo:load", this.addEventListeners);
  }

  openModal() {
    this.element.classList.add("w-ai-menu");
    this.element.classList.remove("w-20");
    this.contentTarget.classList.toggle("opacity-0");
  }

  closeModal() {
    this.element.classList.add("w-20");
    this.element.classList.remove("w-ai-menu");
    this.contentTarget.classList.toggle("opacity-0");
  }
}
