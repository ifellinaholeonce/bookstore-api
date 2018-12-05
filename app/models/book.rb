# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, polymorphic: true

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
