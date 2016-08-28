class AddNewFieldsCouncillors < ActiveRecord::Migration[5.0]
  def change
    remove_column :councillors, :voter_registration
    remove_column :councillors, :gender
    remove_attachment :councillors, :avatar

    add_column :councillors, :username, :string, index: { unique: true }
    add_column :councillors, :encrypted_password, :string

    add_column :councillors, :is_active, :boolean, null: false, default: true
    add_column :councillors, :is_holder, :boolean, null: false, default: false
  end
end
