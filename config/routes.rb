Rails.application.routes.draw do
  devise_for :users
  resources :attachments, only: [:destroy]
  resources :comments, only: [:destroy]

  concern :votable do
    member do
      post 'positive_vote'
      post 'negative_vote'
      delete 're_vote'
    end
  end

  root to: 'questions#index'
  resources :questions, except: [:edit], concerns: [:votable] do
    resources :answers, except: [:index, :show], concerns: [:votable], shallow: true do
      patch :set_best, on: :member
      resources :comments, only: [:create]
    end
    resources :comments, only: [:create]
  end

  mount ActionCable.server => '/cable'
end
