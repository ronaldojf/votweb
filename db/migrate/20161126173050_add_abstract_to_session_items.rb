class AddAbstractToSessionItems < ActiveRecord::Migration[5.0]
  def change
    add_column :session_items, :abstract, :string
  end
end
