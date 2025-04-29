class Note < ApplicationRecord
  belongs_to :notebook
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_rich_text :content

  scope :recent, -> { order(updated_at: :desc) }
end
