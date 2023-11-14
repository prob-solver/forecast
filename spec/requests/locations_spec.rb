require 'rails_helper'

RSpec.describe 'Locations', type: :request do
  describe 'GET /' do
    it 'return 200' do
      get '/'
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /locations' do
    it 'return 200' do
      get '/locations'
      expect(response).to have_http_status(200)
    end
  end
end
