class HomeController < ApplicationController
  def index
    @recent_notes = current_user.notes.recent.includes(:notebook)
  end
end
