class AddIsDoneToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :is_done, :boolean, null: false, default: false
  end
end
