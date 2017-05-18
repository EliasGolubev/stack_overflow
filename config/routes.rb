Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :attachments, only: [:destroy]
  resources :comments, only: [:destroy]

  concern :votable do
    member do
      post 'positive_vote'
      post 'negative_vote'
      delete 're_vote'
    end
  end

  devise_scope :user do
    post 'set_email', to: 'omniauth_callbacks#set_email'
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :list, on: :collection
      end
    end
  end

  root to: 'questions#index'
  resources :questions, except: [:edit], concerns: [:votable] do
    resources :answers, except: [:index, :show], concerns: [:votable], shallow: true do
      patch :set_best, on: :member
      resources :comments, only: [:create], defaults: { commentable: 'answer' }
    end
    resources :comments, only: [:create], defaults: { commentable: 'question' }
  end

  mount ActionCable.server => '/cable'
end
