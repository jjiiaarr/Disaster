Rails.application.routes.draw do
  get 'users/index'
  devise_for :users

  get 'welcome' => 'welcome#index'
  root 'posts#index'
  get 'users/:id', to: 'users#index', as: 'user'

  resources :posts do
    resources :comments, except: :show
  end
  resources :categories, except: :show
end
