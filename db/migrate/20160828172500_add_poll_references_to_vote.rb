class AddPollReferencesToVote < ActiveRecord::Migration[5.0]
  def change
    change_table :votes do |t|
      t.references :poll, foreign_key: true
      t.integer :kind, null: false, default: 0
    end

    remove_column :votes, :plenary_session_id
    remove_column :votes, :session_item_id
  end
end
