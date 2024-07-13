import { Controller } from "@hotwired/stimulus";
import consumer from "channels/consumer";

// Connects to data-controller="splash"
export default class extends Controller {
  static targets = [
    "top",
    "title",
    "singer",
    "video",
    "youtube",
    "upNext",
    "upNextTitle",
    "upNextSinger",
  ];
  static values = {
    state: String,
  };

  initialize() {
    if (!document.cookie.includes("_karaoke_time_id")) {
      const randomId = Math.random().toString(36).substring(2, 9);
      document.cookie = `_karaoke_time_id=${randomId}`;
    }

    if (this.hasVideoTarget) {
      this.videoTarget.addEventListener("ended", function () {
        this.stateValue = "idle";
      });
    }

    let splashController = this;
    this.splashChannel = consumer.subscriptions.create(
      { channel: "SplashChannel" },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log("connected to SplashChannel");
          splashController.connected();
        },

        disconnected() {
          console.log("disconnecting");
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          if (data["event"] == "play") {
            splashController.playUrl(
              data["url"],
              data["title"],
              data["singer"],
            );
          } else if (data["event"] == "queue") {
            splashController.queue(data["title"], data["singer"]);
          }
        },

        ping(state) {
          // this.perform("presence", { state: state })
        },

        ended() {
          this.perform("ended", {});
        },

        embeddedStateChange(state) {
          if (state === 0) {
            this.perform("ended", {});
          }
        },
      },
    );

    this.splashChannel.ping();
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
      document.body.style.cursor = "none";
      this.cursorVisible = false;
    }, 5000);
  }

  queue(title, singer) {
    this.upNextTitleTarget.textContent = title;
    this.upNextSingerTarget.textContent = singer;
    this.upNextTarget.classList.remove("hidden");
  }

  play() {
    if (!this.videoTarget.querySelector("source").src) {
      return;
    }

    this.videoTarget.play();
    this.stateValue = "playing";
  }

  playUrl(url, title, singer) {
    console.log(`play: ${url}`);

    this.topTarget.classList.add("absolute");
    this.topTarget.classList.remove("hidden");

    this.titleTarget.textContent = title;
    this.singerTarget.textContent = singer;

    this.upNextTarget.classList.add("hidden");

    this.videoTarget.src = url;
    this.videoTarget.load();
    this.videoTarget.classList.remove("hidden");
    this.videoTarget.play();

    this.play();
  }

  ended() {
    // console.log("ended");
    this.splashChannel.ended();
  }

  // connect() {
  //   console.log("connect");
  // }

  connected() {
    // console.log("connected");
    this.ping();
  }

  ping() {
    this.splashChannel.ping(this.stateValue);
    setTimeout(() => {
      this.ping();
    }, 5000);
  }

  // disconnect() {
  //   this.splashChannel.perform("unfollow")
  // }

  // listen() {
  //   if (this.splashChannel) {
  //     this.splashChannel.perform("follow")
  //   }
  // }
}
