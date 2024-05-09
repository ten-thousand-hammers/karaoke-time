import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="splash"
export default class extends Controller {
  static targets = [ "top", "title", "singer", "video", "permissions", "upNext", "upNextTitle", "upNextSinger" ]

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
          splashController.play(data["url"], data["title"], data["singer"])
        } else if (data["event"] == "queue") {
          splashController.queue(data["title"], data["singer"])
        }
      }
    });
  }

  queue(title, singer) {
    this.upNextTitleTarget.textContent = title
    this.upNextSingerTarget.textContent = singer
    this.upNextTarget.classList.remove("hidden")
  }

  play(url, title, singer) {
    console.log(`play: ${url}`)

    this.topTarget.classList.add("absolute")
    this.topTarget.classList.remove("hidden")

    this.titleTarget.textContent = title
    this.singerTarget.textContent = singer

    this.upNextTarget.classList.add("hidden")

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
