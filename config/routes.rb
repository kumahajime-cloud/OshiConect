Rails.application.routes.draw do
  devise_for :users

  root 'posts#index'

  resources :posts do
    member do
      post 'like'
      delete 'unlike'
    end
    collection do
      get 'search'
    end
  end

  resources :profiles, only: [:show, :edit, :update] do
    resources :oshis, only: [:create, :destroy]
  end

  resource :mypage, only: [:show] do
    get 'liked_posts'
  end

  get 'hashtags/:name', to: 'hashtags#show', as: 'hashtag'
end
