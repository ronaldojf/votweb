class AddColumnsKindAndIsTestToPlenarySessions < ActiveRecord::Migration[5.0]
  def change
    add_column :plenary_sessions, :kind, :integer, null: false, default: 0
    add_column :plenary_sessions, :is_test, :boolean, null: false, default: false
  end
end
