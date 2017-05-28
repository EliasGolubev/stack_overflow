require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do 
  sign_in_user  
    
  describe '#POST' do 
    let!(:question){ create(:question) }
    
    it 'create new subscription with question in db' do
      expect { post :create, question_id: question, format: :js }.to change(Subscription, :count).by(1) 
    end

    it 'render create tamplate' do 
      post :create, question_id: question, format: :js
      expect(response).to render_template :create
    end
  end

  describe '#DELETE' do 
    let!(:subscription) { create(:subscription, user: @user) }
    
    it 'destroy subscription with question in db' do
      expect { delete :destroy, id: subscription.id, format: :js }.to change(Subscription, :count).by(-1)
    end 

    it 'renders delete tamplate' do 
      delete :destroy, id: subscription.id, format: :js
      expect(response).to render_template :destroy
    end
  end 
end