class RenameTableAldermenToCouncillors < ActiveRecord::Migration[5.0]
  def change
    rename_table :aldermen, :councillors
  end
end
