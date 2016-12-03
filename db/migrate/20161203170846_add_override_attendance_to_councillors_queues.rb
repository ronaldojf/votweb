class AddOverrideAttendanceToCouncillorsQueues < ActiveRecord::Migration[5.0]
  def change
    add_column :councillors_queues, :override_attendance, :boolean, null: false, default: false
  end
end
