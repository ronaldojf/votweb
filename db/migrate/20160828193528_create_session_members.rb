class CreateSessionMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :session_members do |t|
      t.references :plenary_session, foreign_key: true
      t.references :councillor, foreign_key: true
      t.boolean :is_present
      t.boolean :is_president, null: false, default: false

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
