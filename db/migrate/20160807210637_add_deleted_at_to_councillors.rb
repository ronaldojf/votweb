class AddDeletedAtToCouncillors < ActiveRecord::Migration[5.0]
  def change
    add_column :councillors, :deleted_at, :datetime, index: true
  end
end
