class AddPlenarySessionReferencesToCouncillorsQueue < ActiveRecord::Migration[5.0]
  def change
    add_reference :councillors_queues, :plenary_session, foreign_key: true
  end
end
