class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :tagger, index: true
      t.references :taggee
      t.datetime :claimed

      t.timestamps
    end

    add_index :tags, :taggee_id, unique: true

  end
end
