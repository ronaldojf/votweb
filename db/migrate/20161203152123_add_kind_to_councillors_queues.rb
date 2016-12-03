class AddKindToCouncillorsQueues < ActiveRecord::Migration[5.0]
  def change
    add_column :councillors_queues, :kind, :integer, null: false, default: 0
  end
end
