class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slug
      t.string :location
      t.string :timezone
      t.string :description

      t.timestamps
    end
  end
end
