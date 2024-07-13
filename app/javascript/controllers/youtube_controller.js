import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="youtube"
export default class extends Controller {
  static targets = ["youtube", "player"];
  static values = {
    videoId: String,
  };

  initialize() {
    if (typeof YT !== "object" || typeof YT.Player !== "function") {
      window.onYouTubePlayerAPIReady = () => {
        this.initializeYouTube();
      };
    } else {
      this.initializeYouTube();
    }
  }

  initializeYouTube() {
    let player = new YT.Player(this.playerTarget, {
      width: "100%",
      videoId: this.videoIdValue,
      playerVars: {
        autoplay: 1,
        // controls: 0,
        // disablekb: 1,
        // enablejsapi: 1,
        // fs: 0,
        // modestbranding: 1,
        // playsinline: 1,
        // rel: 0,
        // showinfo: 0,
      },
    });
    player.addEventListener("onStateChange", (event) => {
      if (event.data === YT.PlayerState.ENDED) {
        this.youtubeTarget.dispatchEvent(new Event("ended"));
      }
    });
  }
}
