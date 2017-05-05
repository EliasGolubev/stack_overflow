require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do 
  let(:user) { create :user }

  before do 
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #facebook' do 
    context 'with new user' do 
      before do 
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'facebook', 
          uid: '1234567', 
          info: { 
            name: 'John Doe', 
            email: 'test@email.com' 
          }
        )
        get :facebook
      end

      it 'assings user to @user' do 
        expect(assigns :user).to be_a(User)
      end
    end
  end

  describe 'GET #twitter' do 
    context 'with non email' do 
      before do 
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'twitter', 
          uid: '12345678', 
          info: { 
            name: 'John Doe' 
          })
        get :twitter
      end

      it { should_not be_user_signed_in }

      it 'render template set email' do 
        expect(response).to render_template :set_email
      end
    end

    context 'with new user' do 
      before do 
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: 'twitter',
          uid: '12345678', 
          info: { name: 'John Doe', email: 'test@email.com' })
        
        get :twitter
      end

      it 'assigns user to @user' do 
        expect(assigns :user).to be_a(User)
      end
    end
  end
end