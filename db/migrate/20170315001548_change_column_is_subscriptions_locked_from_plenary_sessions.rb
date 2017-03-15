class ChangeColumnIsSubscriptionsLockedFromPlenarySessions < ActiveRecord::Migration[5.0]
  def change
    change_column :plenary_sessions, :is_subscriptions_locked, :boolean, null: false, default: true
  end
end
