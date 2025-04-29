import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "status", "editor"]
  static values = {
    saveInterval: { type: Number, default: 3000 },
    debounceTimeout: { type: Number, default: 500 }
  }

  connect() {
    this.debouncedSave = this.debounce(this.save.bind(this), this.debounceTimeoutValue)
    this.setupAutosave()
  }

  setupAutosave() {
    this.editorTarget.addEventListener("trix-change", () => {
      this.markUnsaved()
      this.debouncedSave()
    })

    this.formTarget.querySelector("input[name*='title']").addEventListener("input", () => {
      this.markUnsaved()
      this.debouncedSave()
    })
  }

  markUnsaved() {
    this.statusTarget.textContent = "Unsaved changes..."
    this.statusTarget.classList.remove("saved")
    this.statusTarget.classList.add("unsaved")
  }

  async save() {
    try {
      this.statusTarget.textContent = "Saving..."
      
      const response = await fetch(this.formTarget.action, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Accept": "application/json"
        },
        body: new FormData(this.formTarget)
      })

      if (!response.ok) throw new Error("Save failed")

      this.statusTarget.textContent = "All changes saved"
      this.statusTarget.classList.remove("unsaved")
      this.statusTarget.classList.add("saved")
    } catch (error) {
      this.statusTarget.textContent = "Save failed - retrying"
      this.statusTarget.classList.add("error")
      setTimeout(() => this.save(), 5000)
    }
  }

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }

  disconnect() {
    if (this.statusTarget.classList.contains("unsaved")) {
      this.save()
    }
  }
} 