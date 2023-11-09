class ForecastsController < ApplicationController

  def index

  end

  def create
    @suggestions = LocationLookupService.suggestions(params[:location])
    if @suggestions.size == 1
      @forecast = ::ForecastService.new(@suggestions.first).get_forecast
    end

    render :index
  end

  private

  def zip
    @zip ||= begin
               LocationLookupService.get_full_address(params[:location])
             end
  end
end
