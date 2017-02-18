class AddSortToSessionItems < ActiveRecord::Migration[5.0]
  def change
    add_column :session_items, :sort, :integer
  end
end
