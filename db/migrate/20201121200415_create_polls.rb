# frozen_string_literal: true

class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :slug
      t.datetime :scheduled_at
      t.datetime :due_at
      t.integer :created_by_id
      t.string :status, default: 'pending'
      t.string :title

      t.timestamps
    end
    add_index :polls, :slug, unique: true
  end
end
