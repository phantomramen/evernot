class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :notebooks, dependent: :destroy
  has_many :notes, through: :notebooks
  has_many :tags, dependent: :destroy

  belongs_to :default_notebook, class_name: "Notebook", optional: true

  after_create :create_default_notebook

  private

  def create_default_notebook
    notebook = notebooks.create!(name: "First Notebook")
    update!(default_notebook: notebook)
  end
end
