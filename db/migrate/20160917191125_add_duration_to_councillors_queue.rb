class AddDurationToCouncillorsQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :councillors_queues, :duration, :integer
  end
end
