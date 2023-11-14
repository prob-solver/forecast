require 'rails_helper'

RSpec.describe 'Api::V1::Locations', type: :request do
  before do
    aws_result = double('aws_result')
    allow(aws_result).to receive(:results).and_return(
      [
        Aws::LocationService::Types::SearchForSuggestionsResult.new(text: '78681, Round Rock, TX, USA',
                                                                    place_id: 'random_id1'),
        Aws::LocationService::Types::SearchForSuggestionsResult.new(
          text: '78681, Villa de Ramos, San Luis Potosí, MEX', place_id: 'random_id2'
        )
      ]
    )

    allow_any_instance_of(Aws::LocationService::Client).to receive(:search_place_index_for_suggestions)
      .and_return(aws_result)
  end

  describe 'GET /api/v1/locations/suggestions' do
    context 'query has value' do
      it 'should return 200' do
        get '/api/v1/locations/suggestions', params: { query: '78681' }
        expect(response).to have_http_status(200)
      end
      it 'should return array' do
        get '/api/v1/locations/suggestions', params: { query: '78681' }
        expect(json_body).to be_a(Array)
      end
    end

    context 'query is empty' do
      it 'should get 400' do
        get '/api/v1/locations/suggestions'
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /locations/:place_id' do
    context 'place_id is valid' do
      before do
        allow(LocationService).to receive(:get_place).and_return(
          Aws::LocationService::Types::Place.new(
            label: '78681, Round Rock, TX, USA',
            geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
            postal_code: '78681'
          )
        )
      end

      it 'should return 200' do
        get '/api/v1/locations/a_place_id'
        expect(response).to have_http_status(200)
      end

      it 'should return location json' do
        get '/api/v1/locations/a_place_id'
        expect(json_body).to be_a(Hash)
        expect(json_body).to include('id', 'place')
        expect(json_body['place']).to include('label', 'geometry', 'postal_code')
      end
    end

    context 'place_id is invalid' do
      before do
        allow(LocationService).to receive(:get_place).and_return(nil)
      end
      it 'should return 404' do
        get '/api/v1/locations/a_invalid_place_id'
        expect(response).to have_http_status(404)
      end
    end
  end
end
