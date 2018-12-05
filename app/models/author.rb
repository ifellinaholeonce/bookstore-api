# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books
  has_many :published, foreign_key: :publisher_id,
                       class_name: 'Book',
                       as: :publisher,
                       dependent: :destroy
  validates :name, presence: true
  def discount
    10
  end

  def create_with_book
    ActiveRecord::Base.transaction do
      save!
      self.books.new(
        title: Faker::Book.title,
        price: rand(5..50),
        publisher: self
      ).save!
    end
  rescue ActiveRecord::RecordInvalid
    return false
  end
end
