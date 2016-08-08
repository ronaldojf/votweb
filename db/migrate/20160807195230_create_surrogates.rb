class CreateSurrogates < ActiveRecord::Migration[5.0]
  def change
    create_table :surrogates do |t|
      t.string :name
      t.string :voter_registration

      t.timestamps
    end
  end
end
