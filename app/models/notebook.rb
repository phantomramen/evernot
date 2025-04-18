class Notebook < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  before_destroy :ensure_not_default

  private

  def ensure_not_default
    throw(:abort) if user.default_notebook_id == id
  end
end
