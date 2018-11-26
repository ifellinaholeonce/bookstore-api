# frozen_string_literal: true

class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :biography, :discount
  has_many :books
  has_many :published
end
