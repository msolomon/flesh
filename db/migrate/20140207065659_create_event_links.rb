class CreateEventLinks < ActiveRecord::Migration
  def change
    create_table :event_links do |t|
      t.references :event
      t.references :eventable, polymorphic: true

      t.timestamps
    end
  end
end
