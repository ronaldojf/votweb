class CreateCountdowns < ActiveRecord::Migration[5.0]
  def change
    create_table :countdowns do |t|
      t.references :plenary_session, foreign_key: true
      t.string :description
      t.integer :duration

      t.timestamps
    end
  end
end
