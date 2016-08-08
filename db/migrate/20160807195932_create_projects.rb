class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :councillor, foreign_key: true
      t.string :title

      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
