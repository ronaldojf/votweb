class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :project, foreign_key: true
      t.references :councillor, foreign_key: true
      t.references :plenary_session, foreign_key: true

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
