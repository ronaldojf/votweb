class CreateAldermen < ActiveRecord::Migration[5.0]
  def change
    create_table :aldermen do |t|
      t.string :name
      t.string :voter_registration
      t.integer :gender, null: false, default: 0
      t.references :party, foreign_key: true
      t.attachment :avatar

      t.timestamps
    end
  end
end
