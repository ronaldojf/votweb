class AddAcceptanceInSessionItems < ActiveRecord::Migration[5.0]
  def change
    add_column :session_items, :acceptance, :integer, null: false, default: 0
  end
end
