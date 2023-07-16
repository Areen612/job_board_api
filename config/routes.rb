Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'logout', to: 'authentication#logout'
      resources :users, only: [:create]
      resources :job_posts, only: [:index, :show, :create, :update, :destroy] do
        resources :job_applications, only: [:create, :destroy, :show] do
          delete 'destroy', to: 'job_applications#destroy'
        end
      end
      get 'job_applications', to: 'job_applications#index'
    end
  end
  post 'login', to: 'sessions#create'
end
