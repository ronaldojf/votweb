class RenameColumnProjectIdToSessionItemIdOfVotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :votes, :project_id, :session_item_id
  end
end
