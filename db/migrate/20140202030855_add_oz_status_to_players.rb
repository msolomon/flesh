class AddOzStatusToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :oz_status, :integer, null: false, default: 0
  end
end
