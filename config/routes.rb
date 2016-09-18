Rails.application.routes.draw do

  localized do
    devise_for :administrators, path: :admin, controllers: { registrations: 'admin/registrations' }
    devise_for :councillors, path: :panel

    namespace :admin do
      resources :administrators do
        patch :unlock
      end

      resources :plenary_sessions do
        scope module: :plenary_sessions do
          resources :session_managements, only: [:index]
        end
      end

      resources :polls, only: [:create] do
        patch :stop, on: :member
      end

      resources :councillors_queues, only: [:create] do
        patch :stop, on: :member
      end

      resources :roles, :councillors, :parties, :session_items

      root 'home#index'
    end

    namespace :panel do
      root 'home#index'
    end

    scope module: :public do
      root 'home#index'
    end
  end
end
