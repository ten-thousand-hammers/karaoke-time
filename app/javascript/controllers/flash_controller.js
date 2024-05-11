import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    setTimeout(() => { this.remove() }, 5000)
  }

  remove() {
    this.element.remove()
  }
}
