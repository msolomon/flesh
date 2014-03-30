class AddSourceToTag < ActiveRecord::Migration
  def change
    add_column :tags, :source, :integer, null: false, default: 0
  end
end
