class CreateAdministrators < ActiveRecord::Migration[5.0]
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :email, null: false, default: '', index: { unique: true }
      t.boolean :main, null: false, default: false
      t.string :encrypted_password, null: false, default: ''

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.datetime :locked_at

      t.timestamps
    end
  end
end
