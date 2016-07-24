json.extract! @administrator, :name, :email, :main, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :locked_at, :created_at, :updated_at

json.set! :roles do
  json.array!(@administrator.roles) do |role|
    json.extract! role, :id, :description, :full_control, :created_at, :updated_at
  end
end
