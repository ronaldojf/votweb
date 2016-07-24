class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.string :subject
      t.references :role, index: true, foreign_key: true
      t.string :actions, array: true, default: []

      t.timestamps
    end
  end
end
