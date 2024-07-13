import { Controller } from "@hotwired/stimulus";
import consumer from "channels/consumer";

// Connects to data-controller="splash"
export default class extends Controller {
  static targets = ["video"];

  static values = {
    state: String,
  };

  initialize() {
    if (!document.cookie.includes("_karaoke_time_id")) {
      const randomId = Math.random().toString(36).substring(2, 9);
      document.cookie = `_karaoke_time_id=${randomId}`;
    }

    let splashController = this;
    this.splashChannel = consumer.subscriptions.create(
      {
        channel: "SplashChannel",
      },
      {
        ended() {
          this.perform("ended", {});
        },
      },
    );
  }

  play() {
    if (!this.videoTarget.querySelector("source").src) {
      return;
    }

    this.videoTarget.play();
    this.stateValue = "playing";
  }

  ended() {
    this.splashChannel.ended();
    this.stateValue = "idle";
  }
}
