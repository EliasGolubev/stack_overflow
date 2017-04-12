Rails.application.routes.draw do
  devise_for :users
  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      post 'positive_vote'
      post 'negative_vote'
      delete 're_vote'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions, except: [:edit], concerns: [:votable] do
    resources :answers, except: [:index, :show], concerns: [:votable], shallow: true do
      patch :set_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
