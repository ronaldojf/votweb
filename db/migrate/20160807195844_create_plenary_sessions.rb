class CreatePlenarySessions < ActiveRecord::Migration[5.0]
  def change
    create_table :plenary_sessions do |t|
      t.string :title
      t.datetime :start_at
      t.datetime :end_at

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
