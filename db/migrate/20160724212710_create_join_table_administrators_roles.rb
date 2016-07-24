class CreateJoinTableAdministratorsRoles < ActiveRecord::Migration[5.0]
  def change
    create_join_table :administrators, :roles
  end
end
