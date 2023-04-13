Rails.application.routes.draw do
  get 'users/index'
  devise_for :users

  #get 'welcome' => 'welcome#index'
  root 'welcome#index'

  resources :posts do
    resources :comments, except: :show
  end
  resources :categories, except: :show

  get 'users/:id', to: 'users#index'
  get '/:slug', to: 'posts#show'
end
