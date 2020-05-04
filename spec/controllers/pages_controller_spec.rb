require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'home' do
    it 'returns a 200' do
      get :home
      expect(response).to have_http_status(:ok)
    end
  end
end
