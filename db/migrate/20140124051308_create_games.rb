class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :slug
      t.references :organization, index: true
      t.string :timezone
      t.datetime :registration_start
      t.datetime :registration_end
      t.datetime :game_start
      t.datetime :game_end
      t.string :description

      t.timestamps
    end
  end
end
