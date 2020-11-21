# frozen_string_literal: true

class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :name,    null: false
      t.string :address, null: false
      t.float :lat,      null: false, precision: 10, scale: 6
      t.float :long,     null: false, precision: 10, scale: 6
      t.float :rating,                precision: 10, scale: 2
      t.string :country, null: false

      t.timestamps
    end
  end
end
