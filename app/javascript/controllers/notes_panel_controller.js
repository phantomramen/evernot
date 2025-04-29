import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "panel" ]

  connect() {
    this.boundSaveScrollPosition = this.saveScrollPosition.bind(this)
    this.boundRestoreScrollPosition = this.restoreScrollPosition.bind(this)
    
    document.addEventListener('turbo:before-visit', this.boundSaveScrollPosition)
    document.addEventListener('turbo:render', this.boundRestoreScrollPosition)
  }

  disconnect() {
    document.removeEventListener('turbo:before-visit', this.boundSaveScrollPosition)
    document.removeEventListener('turbo:render', this.boundRestoreScrollPosition)
  }

  saveScrollPosition() {
    sessionStorage.setItem('notesScrollPosition', this.element.scrollTop)
  }

  restoreScrollPosition() {
    const scrollPosition = sessionStorage.getItem('notesScrollPosition')
    if (scrollPosition) {
      this.element.scrollTop = parseInt(scrollPosition)
      sessionStorage.removeItem('notesScrollPosition')
    }
  }
}