require 'rails_helper'

RSpec.describe ForecastService do
  include ActiveSupport::Testing::TimeHelpers

  let(:location) do
    Location.new(place:
                   Aws::LocationService::Types::Place.new(
                     label: '78681, Round Rock, TX, USA',
                     geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
                     postal_code: '78681'
                   ),
                 id: 'an_id')
  end
  let(:service) { described_class.new(location) }
  before do
    Rails.cache.clear
  end

  describe '#get_forecast' do
    before do
      allow_any_instance_of(described_class).to receive(:get_remote_forecast).and_return(fixture(:remote_forecasts,
                                                                                                 :round_rock))
    end
    it 'should return TomorrowForecast object' do
      result = service.get_forecast
      expect(result).to be_a(TomorrowForecast)
    end

    it 'fetch_from should eq API for the first time' do
      result = service.get_forecast
      expect(result.fetch_from).to eq('API')
    end

    it 'fetch_from should be cache for the 2nd time' do
      result = service.get_forecast
      expect(result.fetch_from).to eq('API')
      # call it 2nd time
      service2 = described_class.new(location)
      result2 = service2.get_forecast
      expect(result2.fetch_from).to eq('Cache')
    end

    it 'fetch_from should become API again after 30 minutes' do
      result = service.get_forecast
      expect(result.fetch_from).to eq('API')

      travel_to 31.minutes.from_now do
        service2 = described_class.new(location)
        result2 = service2.get_forecast
        expect(result2.fetch_from).to eq('API')
      end
    end
  end
end
