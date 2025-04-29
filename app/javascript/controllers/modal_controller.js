import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "content"]

  connect() {
    document.addEventListener('click', this.handleBackdropClick.bind(this))
    document.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleBackdropClick.bind(this))
    document.removeEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close(event)
    }
  }

  handleBackdropClick(event) {
    if (event.target.classList.contains('modal-backdrop')) {
      this.close(event)
    }
  }

  open(event) {
    event.preventDefault()
    const url = event.currentTarget.dataset.url
    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
    .then(response => {
      return response.text()
    })
    .then(html => {
      const frame = document.querySelector('turbo-frame#modal')

      if (frame) {
        frame.innerHTML = html
      }
    })
    .catch(error => {
      console.error("Error fetching modal content:", error)
    })
  }

  close(event) {
    event.preventDefault()
    const frame = document.querySelector('turbo-frame#modal')
    if (frame) {
      frame.innerHTML = ''
    }
  }

  stop(event) {
    event.stopPropagation()
  }
} 