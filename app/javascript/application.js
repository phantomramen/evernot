// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import "trix"
import "@rails/actiontext"

// Initialize Stimulus
const application = Application.start()
application.debug = false
window.Stimulus = application

// Load all controllers
eagerLoadControllersFrom("controllers", application)
