class RenameTableProjectsToSessionItems < ActiveRecord::Migration[5.0]
  def change
    rename_table :projects, :session_items
  end
end
