class AddDescriptionToCouncillorsQueues < ActiveRecord::Migration[5.0]
  def change
    add_column :councillors_queues, :description, :string
  end
end
