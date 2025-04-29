import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notebooksList", "notebooksListTrigger"]

  connect() {
    this.notebooksListTarget.classList.remove("collapsed")
    this.notebooksListTriggerTarget.classList.remove("collapsed")
  }

  toggleNotebooks() {
    this.notebooksListTarget.classList.toggle("collapsed")
    this.notebooksListTriggerTarget.classList.toggle("collapsed")
  }
} 