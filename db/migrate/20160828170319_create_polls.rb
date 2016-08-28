class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.integer :process, null: false, default: 0
      t.references :plenary_session, foreign_key: true
      t.references :session_item, foreign_key: true
      t.string :description
      t.integer :duration

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
