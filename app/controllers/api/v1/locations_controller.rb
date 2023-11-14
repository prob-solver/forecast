class Api::V1::LocationsController < Api::V1::BaseController
  def suggestions
    suggestions = LocationService.search_suggestions(params.require(:query))
    render json: format_suggestions(suggestions)
  end

  def show
    location = LocationService.find_location!(params[:id])
    render json: location
  end

  private

  def format_suggestions(suggestions)
    suggestions.map { |s| { id: s['place_id'], text: s['text'] } }
  end
end
