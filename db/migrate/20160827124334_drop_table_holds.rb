class DropTableHolds < ActiveRecord::Migration[5.0]
  def change
    drop_table :holds
  end
end
