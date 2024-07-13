import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="permissions"
export default class extends Controller {
  static targets = ["permissions"];

  initialize() {
    this.acceptPermissions();
  }

  acceptPermissions() {
    let permissionVideo = this.element.querySelector("video");
    var permissionVideoPromise = permissionVideo.play();
    if (permissionVideoPromise === undefined) {
      return;
    }

    permissionVideoPromise
      .then((_) => {
        // Autoplay started!
        this.acceptedPermissions();
      })
      .catch((error) => {
        // Autoplay not allowed!
        permissionVideo.classList.add("hidden");
      });
  }

  acceptedPermissions() {
    this.element.classList.add("hidden");
    this.dispatch("accepted");
  }
}
