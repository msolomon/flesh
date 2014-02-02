class AddHumanCodeToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :human_code, :string
  end
end
