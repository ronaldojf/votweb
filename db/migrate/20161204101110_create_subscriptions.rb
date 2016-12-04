class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :plenary_session, foreign_key: true
      t.references :councillor, foreign_key: true
      t.integer :kind, null: false, default: 0

      t.timestamps
    end
  end
end
