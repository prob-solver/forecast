require 'rails_helper'

RSpec.describe "Api::V1::Forecasts", type: :request do
  describe "GET /api/v1/locations/:id/forecasts" do
    before do
      allow(LocationSuggestionService).to receive(:get_place).and_return(
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
          {
            "timelines": {
              "minutely": [{
                             "time" => "2023-11-12T05:00:00Z",
                             "values" => {"cloudBase"=>0.08,
                                          "cloudCeiling"=>0.08,
                                          "cloudCover"=>100,
                                          "dewPoint"=>55.4,
                                          "freezingRainIntensity"=>0,
                                          "humidity"=>93,
                                          "precipitationProbability"=>0,
                                          "pressureSurfaceLevel"=>29.41,
                                          "rainIntensity"=>0,
                                          "sleetIntensity"=>0,
                                          "snowIntensity"=>0,
                                          "temperature"=>57.43,
                                          "temperatureApparent"=>57.43,
                                          "uvHealthConcern"=>0,
                                          "uvIndex"=>0,
                                          "visibility"=>8.7,
                                          "weatherCode"=>1001,
                                          "windDirection"=>74.38,
                                          "windGust"=>0,
                                          "windSpeed"=>0}
                           }],
              "hourly": [{
                           "time" => "2023-11-12T05:00:00Z",
                           "values" => {"cloudBase"=>0.08,
                                        "cloudCeiling"=>0.08,
                                        "cloudCover"=>100,
                                        "dewPoint"=>55.4,
                                        "evapotranspiration"=>0.001,
                                        "freezingRainIntensity"=>0,
                                        "humidity"=>93,
                                        "iceAccumulation"=>0,
                                        "iceAccumulationLwe"=>0,
                                        "precipitationProbability"=>0,
                                        "pressureSurfaceLevel"=>29.41,
                                        "rainAccumulation"=>0,
                                        "rainAccumulationLwe"=>0,
                                        "rainIntensity"=>0,
                                        "sleetAccumulation"=>0,
                                        "sleetAccumulationLwe"=>0,
                                        "sleetIntensity"=>0,
                                        "snowAccumulation"=>0,
                                        "snowAccumulationLwe"=>0,
                                        "snowDepth"=>0,
                                        "snowIntensity"=>0,
                                        "temperature"=>57.43,
                                        "temperatureApparent"=>57.43,
                                        "uvHealthConcern"=>0,
                                        "uvIndex"=>0,
                                        "visibility"=>8.7,
                                        "weatherCode"=>1001,
                                        "windDirection"=>74.38,
                                        "windGust"=>0,
                                        "windSpeed"=>0}
                         }],
              "daily" => [{
                            "time" => "2023-11-11T12:00:00Z",
                            "values" => {"cloudBaseAvg"=>0.36,
                                         "cloudBaseMax"=>2.11,
                                         "cloudBaseMin"=>0.04,
                                         "cloudCeilingAvg"=>0.63,
                                         "cloudCeilingMax"=>6.44,
                                         "cloudCeilingMin"=>0,
                                         "cloudCoverAvg"=>99.04,
                                         "cloudCoverMax"=>100,
                                         "cloudCoverMin"=>80,
                                         "dewPointAvg"=>54.18,
                                         "dewPointMax"=>56.08,
                                         "dewPointMin"=>50.56,
                                         "evapotranspirationAvg"=>0.003,
                                         "evapotranspirationMax"=>0.009,
                                         "evapotranspirationMin"=>0.001,
                                         "evapotranspirationSum"=>0.066,
                                         "freezingRainIntensityAvg"=>0,
                                         "freezingRainIntensityMax"=>0,
                                         "freezingRainIntensityMin"=>0,
                                         "humidityAvg"=>89.66,
                                         "humidityMax"=>96,
                                         "humidityMin"=>85,
                                         "iceAccumulationAvg"=>0,
                                         "iceAccumulationLweAvg"=>0,
                                         "iceAccumulationLweMax"=>0,
                                         "iceAccumulationLweMin"=>0,
                                         "iceAccumulationLweSum"=>0,
                                         "iceAccumulationMax"=>0,
                                         "iceAccumulationMin"=>0,
                                         "iceAccumulationSum"=>0,
                                         "moonriseTime"=>"2023-11-11T11:05:41Z",
                                         "moonsetTime"=>"2023-11-11T22:33:03Z",
                                         "precipitationProbabilityAvg"=>0,
                                         "precipitationProbabilityMax"=>0,
                                         "precipitationProbabilityMin"=>0,
                                         "pressureSurfaceLevelAvg"=>29.4,
                                         "pressureSurfaceLevelMax"=>29.42,
                                         "pressureSurfaceLevelMin"=>29.37,
                                         "rainAccumulationAvg"=>0,
                                         "rainAccumulationLweAvg"=>0,
                                         "rainAccumulationLweMax"=>0,
                                         "rainAccumulationLweMin"=>0,
                                         "rainAccumulationMax"=>0,
                                         "rainAccumulationMin"=>0,
                                         "rainAccumulationSum"=>0,
                                         "rainIntensityAvg"=>0,
                                         "rainIntensityMax"=>0,
                                         "rainIntensityMin"=>0,
                                         "sleetAccumulationAvg"=>0,
                                         "sleetAccumulationLweAvg"=>0,
                                         "sleetAccumulationLweMax"=>0,
                                         "sleetAccumulationLweMin"=>0,
                                         "sleetAccumulationLweSum"=>0,
                                         "sleetAccumulationMax"=>0,
                                         "sleetAccumulationMin"=>0,
                                         "sleetIntensityAvg"=>0,
                                         "sleetIntensityMax"=>0,
                                         "sleetIntensityMin"=>0,
                                         "snowAccumulationAvg"=>0,
                                         "snowAccumulationLweAvg"=>0,
                                         "snowAccumulationLweMax"=>0,
                                         "snowAccumulationLweMin"=>0,
                                         "snowAccumulationLweSum"=>0,
                                         "snowAccumulationMax"=>0,
                                         "snowAccumulationMin"=>0,
                                         "snowAccumulationSum"=>0,
                                         "snowDepthAvg"=>0,
                                         "snowDepthMax"=>0,
                                         "snowDepthMin"=>0,
                                         "snowDepthSum"=>0,
                                         "snowIntensityAvg"=>0,
                                         "snowIntensityMax"=>0,
                                         "snowIntensityMin"=>0,
                                         "sunriseTime"=>"2023-11-11T12:49:00Z",
                                         "sunsetTime"=>"2023-11-11T23:39:00Z",
                                         "temperatureApparentAvg"=>57.26,
                                         "temperatureApparentMax"=>60.24,
                                         "temperatureApparentMin"=>51.8,
                                         "temperatureAvg"=>57.26,
                                         "temperatureMax"=>60.24,
                                         "temperatureMin"=>51.8,
                                         "uvHealthConcernAvg"=>0,
                                         "uvHealthConcernMax"=>1,
                                         "uvHealthConcernMin"=>0,
                                         "uvIndexAvg"=>0,
                                         "uvIndexMax"=>3,
                                         "uvIndexMin"=>0,
                                         "visibilityAvg"=>9.07,
                                         "visibilityMax"=>9.94,
                                         "visibilityMin"=>8.01,
                                         "weatherCodeMax"=>1001,
                                         "weatherCodeMin"=>1001,
                                         "windDirectionAvg"=>82.49,
                                         "windGustAvg"=>5.74,
                                         "windGustMax"=>16.18,
                                         "windGustMin"=>0,
                                         "windSpeedAvg"=>1.46,
                                         "windSpeedMax"=>4.71,
                                         "windSpeedMin"=>0}
                          }]
            },
            "location": {
              "lat"=>30.50801658630371,
              "lon"=>-97.70895385742188,
              "name"=>"Williamson County, 78681, Texas, United States"
            }
          }
        )
      end
      it "return 200" do
        get "/api/v1/locations/a_location_id/forecasts"
        expect(response).to have_http_status(200)
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
