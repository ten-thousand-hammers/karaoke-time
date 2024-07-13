import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="permissions"
export default class extends Controller {
  static targets = ["permissions"];

  initialize() {
    let permissionVideo = this.element.querySelector("video");
    var permissionVideoPromise = permissionVideo.play();
    if (permissionVideoPromise !== undefined) {
      permissionVideoPromise
        .then((_) => {
          // Autoplay started!
          console.log("autoplay started");
          this.acceptPermissions();
        })
        .catch((error) => {
          // Autoplay not allowed!
          console.log("autoplay not allowed");
          permissionVideo.classList.add("hidden");
        });
    }
  }

  acceptPermissions() {
    this.element.classList.add("hidden");
    this.dispatch("accepted");
  }
}
