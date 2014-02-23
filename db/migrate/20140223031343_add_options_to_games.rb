class AddOptionsToGames < ActiveRecord::Migration
  def change
    add_column :games, :options, :hstore
  end
end
