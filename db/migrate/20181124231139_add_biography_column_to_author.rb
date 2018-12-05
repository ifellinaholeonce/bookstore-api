# frozen_string_literal: true

class AddBiographyColumnToAuthor < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :biography, :text
  end
end
