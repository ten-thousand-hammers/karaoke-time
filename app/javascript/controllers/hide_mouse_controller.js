import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hide-mouse"
export default class extends Controller {
  connect() {
    this.hideMouse();
  }

  mousemove() {
    if (this.mouseTimer) {
      window.clearTimeout(this.mouseTimer);
    }

    if (!this.cursorVisible) {
      document.body.style.cursor = "default";
      this.cursorVisible = true;
    }

    this.mouseTimer = window.setTimeout(() => {
      this.mouseTimer = null;
      this.hideMouse();
    }, 5000);
  }

  hideMouse() {
    document.body.style.cursor = "none";
    this.cursorVisible = false;
  }
}
