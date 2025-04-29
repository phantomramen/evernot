import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "menu"]
  static values = {
    position: { type: String, default: "bottom-right" },
    closeOnClickOutside: { type: Boolean, default: true },
    closeOnItemClick: { type: Boolean, default: true }
  }

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("dropdown__menu--visible")
  }

  handleClickOutside(event) {
    if (!this.closeOnClickOutsideValue) return
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("dropdown__menu--visible")
    }
  }

  close() {
    this.menuTarget.classList.remove("dropdown__menu--visible")
  }
} 