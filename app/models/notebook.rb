class Notebook < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :name, presence: true

  before_destroy :ensure_not_default

  private

  def ensure_not_default
    if user.default_notebook_id == id
      errors.add(:base, "Cannot delete the default notebook. Please set another notebook as default first.")
      throw(:abort)
    end
  end
end
