class Api::V1::ForecastsController < Api::V1::BaseController

  def index
    @forecast = ForecastService.new(location).get_forecast
    render json: @forecast
  end

  private

  def location
    @location ||= LocationSuggestionService.find_location!(params[:location_id])
  end
end
