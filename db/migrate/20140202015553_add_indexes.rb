class AddIndexes < ActiveRecord::Migration
  def change
    add_index :users, :phone, unique: true

    add_index :organizations, :name, unique: true
    add_index :organizations, :slug, unique: true

    add_index :games, [:organization_id, :slug], unique: true

    add_index :players, [:user_id, :game_id], unique: true
    add_index :players, [:game_id, :human_code], unique: true
  end
end
