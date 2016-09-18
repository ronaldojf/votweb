class AddUsernameIndexToCouncillors < ActiveRecord::Migration[5.0]
  def change
    add_index :councillors, :username, unique: true
  end
end
