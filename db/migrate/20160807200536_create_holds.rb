class CreateHolds < ActiveRecord::Migration[5.0]
  def change
    create_table :holds do |t|
      t.string :reference_id

      t.timestamps
    end
  end
end
