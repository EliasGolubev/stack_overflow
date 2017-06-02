require 'rails_helper'

RSpec.describe SearchesController, type: :controller do 
  describe 'GET #show' do 
    before { get :show, query: 'Query test', resourse: 'Questions' }

    it 'assings the requsted query to @query' do
      expect(assigns(:query)).to eq 'Query test'
    end

    it 'assings the requsted resourse to @resourse' do 
      expect(assigns(:resourse)).to eq 'Questions'
    end

    it 'render show view' do
      expect(response).to render_template(:show)
    end
  end
end