class Note < ApplicationRecord
  belongs_to :notebook
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
end
