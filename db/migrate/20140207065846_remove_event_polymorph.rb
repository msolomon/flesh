class RemoveEventPolymorph < ActiveRecord::Migration
  def change
    remove_column :events, :eventable_id
    remove_column :events, :eventable_type
  end
end
