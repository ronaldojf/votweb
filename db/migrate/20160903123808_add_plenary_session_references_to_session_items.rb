class AddPlenarySessionReferencesToSessionItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :session_items, :plenary_session, foreign_key: true
  end
end
