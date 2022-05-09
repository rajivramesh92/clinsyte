require 'sidekiq/web'

Rails.application.routes.draw do

  # Mounting sidekiq page at '/sidekiq' endpoint and allowing only admin users to view it.
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Routes for Rails Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Routes for '/'
  root to: 'home#index'

  devise_for :users, :skip => [ :sessions, :registrations ],
    :controllers => {
      :invitations => 'api/v1/users/invitations'
    }

  # Routes for API
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', :at => '/users',
        :skip => [ :omniauth_callbacks, :confirmable ],
        :controllers => {
          :registrations => 'api/v1/users/registrations',
          :sessions => 'api/v1/users/sessions'
        }

      namespace :users do
        resources :confirmations, :only => [] do
          get :email, :on => :collection
          get :phone_number, :on => :collection
          post :initiate_verification, :on => :collection
          post :resend, :on => :collection
        end

        resources :passwords, :only => [ :create ] do
          post :validate_verification_code, :on => :collection
          post :reset_password, :on => :collection
        end
      end

      # Define the routes for API's here
      resources :patients, :only => [] do
        post :select_physician, :on => :member
        get :physician, :on => :member
        get :deselect_physician, :on => :member
        get :careteam, :on => :member
      end

      resources :users, :only => [ :update, :show ] do
        get :search, :on => :collection
        get :qr_code, :on => :member
        get :busy_slots, :on => :member
        post :destroy

        # Patient chart endpoints
        get :chart, :to => 'users/chart#show', :on => :member
        post :chart, :to => 'users/chart#update', :on => :member
        get 'chart/activities', :to => 'users/chart#activities', :on => :member
        post :approve, :to => 'users/chart#approve', :on => :member
      end

      resources :careteams, :only => :index do
        post :remove_member, :on => :member
        get :activities, :on => :member
        get :summary, :on => :collection
        post :invite_patient, :on => :collection
      end

      resources :notifications, :only => :index do
        post :read, :on => :member
        post :unread, :on => :member
        post :ignore, :on => :collection
      end

      resources :requests, :except => [ :new, :edit, :destroy ]
      resources :slots, :only => [ :create, :update, :destroy ]

      resources :physicians, :only => :update do
        get :slots, :on => :member
        post :make_primary, :on => :member
      end

      resources :appointments, :except => [:show, :new, :edit] do
        post :change_status, :on => :member
        post :cancel, :on => :member
        get :pending, :on => :collection
      end

      resources :appointment_preferences, :only => [] do
        post :toggle_auto_confirm, :on => :collection
      end

      resources :conditions, :only => [ :index ] do
        get :list, :on => :collection
      end
      resources :symptoms, :only => [ :index ]
      resources :medications, :only => [ :index ]
      resources :therapies, :only => [ :index, :show ] do
        get :list, :on => :collection
      end
      resources :surveys do
        post :send_requests, :on => :collection
        post :start, :on => :member
        post :submit, :on => :member
        get :requests, :on => :member
      end
      resources :questions, :only => [] do
        get :statistic, :on => :member
      end
      resources :user_survey_forms, :only => [ :show ] do
        get :requests, :on => :collection
        post :remove_requests, :on => :collection
      end
      resources :survey_configurations, :only => [:create, :index, :destroy]
      resources :treatment_plans, :only => [] do
        post :change_owner, :on => :member
        post :remove_treatment_plan, :on => :member
        resources :treatment_plan_therapies, :only => [] do
          post :take, :on => :member
          post :snooze, :on => :member
        end
      end
      resources :event_dependent_surveys
      resources :templates do
        post :toggle_access_level, :on => :member
        get :check_availability, :on => :collection
      end
      resources :lists
    end
  end

  # Rule to match all other routes
  match "*ignore", to: 'home#index' , :via => [:get]
end
