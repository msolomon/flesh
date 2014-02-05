class AddEvents < ActiveRecord::Migration

  def change
    create_table :events do |t|
      t.integer :event_type, null: false, default: 0
      t.hstore :data
      t.references :eventable, polymorphic: true

      t.timestamps
    end
  end

end
