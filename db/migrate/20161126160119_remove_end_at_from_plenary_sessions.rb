class RemoveEndAtFromPlenarySessions < ActiveRecord::Migration[5.0]
  def change
    remove_column :plenary_sessions, :end_at, :datetime
  end
end
