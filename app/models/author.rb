# frozen_string_literal: true

class Author < ApplicationRecord
  # This translates params from GitHub API
  alias_attribute :title, :name
  alias_attribute :body, :biography

  has_many :books
  has_many :published, foreign_key: :publisher_id,
                       class_name: 'Book',
                       as: :publisher,
                       dependent: :destroy

  def discount
    10
  end
end
