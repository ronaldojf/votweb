class RemoveSessionItemIdFromPolls < ActiveRecord::Migration[5.0]
  def change
    remove_column :polls, :session_item_id
  end
end
