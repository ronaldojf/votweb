Rails.application.routes.draw do

  localized do
    devise_for :administrators, path: :admin, controllers: { registrations: 'admin/registrations' }
    namespace :admin do
      resources :administrators do
        patch :unlock
      end

      resources :roles, :aldermen, :parties

      root 'home#index'
    end

    scope module: :public do
      root 'home#index'
    end
  end
end
