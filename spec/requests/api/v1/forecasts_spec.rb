require 'rails_helper'

RSpec.describe "Api::V1::Forecasts", type: :request do
  before do
    Rails.cache.clear
  end

  describe "GET /api/v1/locations/:id/forecasts" do
    before do
      allow(LocationService).to receive(:get_place).and_return(
        Aws::LocationService::Types::Place.new(
          label: "78681, Round Rock, TX, USA",
          geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
          postal_code: "78681"
        )
      )
    end

    context 'location forecast supported' do
      before do
        allow_any_instance_of(ForecastService).to receive(:get_remote_forecast).and_return(
          fixture(:remote_forecasts, :round_rock)
        )
      end
      it "return 200" do
        get "/api/v1/locations/a_location_id/forecasts"
        expect(response).to have_http_status(200)
      end

      it 'should return TomorrowForecast json' do
        get "/api/v1/locations/a_location_id/forecasts"
        expect(json_body).to include("fetch_from", "data", "postal_code")
      end
    end

    context 'location forecast not supported' do
      before do
        allow_any_instance_of(ForecastService).to receive(:get_remote_forecast).and_raise(ForecastService::ForestBadRequest.new("wrong forecast"))
      end
      it 'should return 400' do
        get "/api/v1/locations/a_location_id/forecasts"
        expect(response).to have_http_status(400)
      end
    end

  end
end
