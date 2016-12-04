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
          resources :session_managements, only: [:index] do
            post :check_members_attendance, on: :collection
          end
        end
      end

      resources :polls, only: [:create] do
        patch :stop, on: :member
      end

      resources :councillors_queues, only: [:create] do
        patch :stop, on: :member
      end

      resources :countdowns, only: [:create] do
        patch :stop, on: :member
      end

      resources :roles, :councillors, :parties, :session_items

      root 'home#index'
    end

    namespace :panel do
      resources :plenary_sessions, only: [] do
        scope module: :plenary_sessions do
          resources :councillors_queues, only: [:update]
          resources :polls, only: [:update]
        end
      end

      root 'home#index'
    end

    scope module: :public do
      resources :plenary_sessions, only: [:show]
      root 'home#index'
    end
  end
end
