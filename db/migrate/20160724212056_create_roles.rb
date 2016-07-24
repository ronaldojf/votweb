class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :description
      t.boolean :full_control, null: false, default: false

      t.timestamps
    end
  end
end
