import { Controller } from "@hotwired/stimulus";
import consumer from "channels/consumer";

// Connects to data-controller="splash"
export default class extends Controller {
  static targets = ["video", "youtubePlayer"];

  static values = {
    state: String,
  };

  initialize() {
    if (!document.cookie.includes("_karaoke_time_id")) {
      const randomId = Math.random().toString(36).substring(2, 9);
      document.cookie = `_karaoke_time_id=${randomId}`;
    }

    this.splashChannel = consumer.subscriptions.create(
      {
        channel: "SplashChannel",
      },
      {
        ended: () => {
          this.ended();
        },
        received: (data) => {
          if (data.action === "togglePause") {
            this.togglePause();
          }
        },
      },
    );

    this.stateValue= "playing";
  }

  play() {
    if (!this.videoTarget.querySelector("source")?.src && !this.hasYoutubePlayerTarget) {
      return;
    }

    if (this.hasYoutubePlayerTarget) {
      this.youtubePlayerTarget.playVideo();
    } else {
      this.videoTarget.play();
    }
    this.stateValue = "playing";
  }

  pause() {
    if (this.hasYoutubePlayerTarget) {
      this.youtubePlayerTarget.pauseVideo();
    } else {
      this.videoTarget.pause();
    }
    this.stateValue = "paused";
  }

  togglePause() {
    if (this.stateValue === "playing") {
      this.pause();
    } else {
      this.play();
    }
  }

  ended() {
    this.splashChannel.ended();
    this.stateValue = "idle";
  }
}
