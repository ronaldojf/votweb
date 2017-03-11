class AddIsSubscriptionsLockedToPlenarySessions < ActiveRecord::Migration[5.0]
  def change
    add_column :plenary_sessions, :is_subscriptions_locked, :boolean, null: false, default: false
  end
end
