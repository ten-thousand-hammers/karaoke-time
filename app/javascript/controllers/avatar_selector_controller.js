import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radio", "image"]

  connect() {
    // Add initial selection if there is one
    const selectedRadio = this.radioTargets.find(radio => radio.checked)
    if (selectedRadio) {
      this.highlightSelected(selectedRadio)
    }
  }

  select(event) {
    // Remove highlight from all images
    this.imageTargets.forEach(img => {
      img.classList.remove("ring-4", "ring-blue-500")
    })

    // Add highlight to selected image
    this.highlightSelected(event.target)
  }

  highlightSelected(radio) {
    const imageId = radio.id.replace("avatar_", "avatar_img_")
    const selectedImage = document.getElementById(imageId)
    if (selectedImage) {
      selectedImage.classList.add("ring-4", "ring-blue-500")
    }
  }
}
