import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  show() {
    this.formTarget.classList.remove("hidden")
    this.formTarget.scrollIntoView({ behavior: "smooth" })
    // Reset form for new ADR creation
    this.resetForm()
  }

  showSupersede() {
    this.formTarget.classList.remove("hidden")
    this.formTarget.scrollIntoView({ behavior: "smooth" })
    // Mark form as supersede mode
    this.setSupersede()
  }

  hide() {
    this.formTarget.classList.add("hidden")
  }

  resetForm() {
    const form = this.formTarget.querySelector('form')
    if (form) {
      const submitBtn = form.querySelector('input[type="submit"]')
      if (submitBtn) {
        submitBtn.value = "Create ADR"
      }
      // Clear form fields
      form.reset()
    }
  }

  setSupersede() {
    const form = this.formTarget.querySelector('form')
    const submitBtn = form.querySelector('input[type="submit"]')
    if (submitBtn) {
      submitBtn.value = "Create Superseding ADR"
    }
  }
}