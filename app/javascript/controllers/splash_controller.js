import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="splash"
export default class extends Controller {
  static targets = [ "video", "permissions" ]

  initialize() {
    console.log("initialize")
    let splashController = this;
    this.splashChannel = consumer.subscriptions.create({ channel: "SplashChannel" }, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("connected to SplashChannel")
      },
    
      disconnected() {
        console.log("disconnecting")
        // Called when the subscription has been terminated by the server
      },
    
      received(data) {
        if (data["event"] == "play") {
          splashController.play(data["url"])
        }
        // Called when there's incoming data on the websocket for this channel
      }
    });
  }

  play(url) {
    console.log(`play: ${url}`)
    this.videoTarget.src = url
    this.videoTarget.load()
    this.videoTarget.classList.remove("hidden")
    this.videoTarget.play()
  }

  acceptPermissions() {
    this.permissionsTarget.classList.add("hidden")
  }

  // connect() {
  //   console.log("connect")
  //   this.splashChannel.perform("disconnect")
  // }

  // disconnect() {
  //   this.splashChannel.perform("unfollow")
  // }

  // listen() {
  //   if (this.splashChannel) {
  //     this.splashChannel.perform("follow")
  //   }
  // }
}
