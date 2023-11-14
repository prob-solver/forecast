require 'rails_helper'

RSpec.describe LocationService do
  describe '.validate_suggestion_query!' do
    context 'string is empty' do
      it 'should raise error' do
        expect do
          described_class.send(:validate_suggestion_query!, '')
        end.to raise_error(LocationService::InvalidQueryString)
      end
    end

    context 'string is greater than 0' do
      it 'should not raise error' do
        expect do
          described_class.send(:validate_suggestion_query!, '78681')
        end.not_to raise_error
      end
    end
  end

  describe '.find_location!' do
    before do
      allow(LocationService).to receive(:get_place).with('id_without_zip').and_return(
        Aws::LocationService::Types::Place.new(
          label: '78681, Round Rock, TX, USA',
          geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
          postal_code: nil
        )
      )

      allow(LocationService).to receive(:get_place).with('id_with_zip').and_return(
        Aws::LocationService::Types::Place.new(
          label: '78681, Round Rock, TX, USA',
          geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
          postal_code: 78_681
        )
      )
    end

    context 'when place do not have zip code' do
      before do
        @place_result = double('aws place search result')
        allow(@place_result).to receive(:results).and_return(
          [
            OpenStruct.new(place: Aws::LocationService::Types::Place.new(
              label: '78681, Round Rock, TX, USA',
              geometry: Aws::LocationService::Types::PlaceGeometry.new(point: [-97.6944, 30.516005]),
              postal_code: 12_345
            ))
          ]
        )
      end
      it 'should call search_place_index_for_position' do
        expect(LocationService.client).to receive(:search_place_index_for_position).and_return(
          @place_result
        )

        LocationService.find_location!('id_without_zip')
      end

      it 'should return a location with zip 78681' do
        expect(LocationService.client).to receive(:search_place_index_for_position).and_return(
          @place_result
        )
        result = LocationService.find_location!('id_without_zip')
        expect(result.place.postal_code).to eq(12_345)
      end
    end

    context 'place has zip code' do
      it 'should return place with zipcode' do
        allow(LocationService.client).to receive(:search_place_index_for_position)

        result = LocationService.find_location!('id_with_zip')
        expect(result.place.postal_code).to eq(78_681)
        expect(LocationService.client).not_to have_received(:search_place_index_for_position)
      end
    end

    context 'place not found' do
      it 'should raise error' do
        allow(LocationService).to receive(:get_place).and_return(nil)
        expect do
          LocationService.find_location!('id_with_zip')
        end.to raise_error(LocationService::LocationNotFound)
      end
    end
  end
end
