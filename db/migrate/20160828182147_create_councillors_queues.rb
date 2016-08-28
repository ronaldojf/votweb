class CreateCouncillorsQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :councillors_queues do |t|
      t.json :councillors_ids, null: false, default: []

      t.timestamps
    end
  end
end
