class AddIndexesToPlenarySessions < ActiveRecord::Migration[5.0]
  def change
    add_index :plenary_sessions, :kind
    add_index :plenary_sessions, :is_test
    add_index :plenary_sessions, [:start_at, :end_at]
  end
end
