import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: Number }
  static targets = ["supersedesInput"]

  open(event) {
    const id = event.currentTarget.dataset.supersedeIdValue
    this.supersedesInputTarget.value = id
    document.getElementById("supersede-modal").classList.remove("hidden")
  }

  close() {
    document.getElementById("supersede-modal").classList.add("hidden")
  }
}
