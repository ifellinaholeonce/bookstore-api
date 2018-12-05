# frozen_string_literal: true

class PublishingHouseSerializer < ActiveModel::Serializer
  attributes :id, :name, :discount
  has_many :published
end
