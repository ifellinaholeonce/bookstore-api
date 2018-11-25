# frozen_string_literal: true

class PublishingHouse < ApplicationRecord
  has_many :published, as: :publisher,
                       foreign_key: :publisher_id,
                       class_name: 'Book',
                       dependent: :destroy
end
