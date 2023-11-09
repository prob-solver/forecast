class Api::V1::LocationsController < Api::V1::BaseController

  def suggestions
    suggestions = LocationSuggestionService.search_suggestions(params[:query])
    render json: format_suggestions(suggestions)
  end

  def show
    location = LocationSuggestionService.find_location!(params[:id])
    render json: location
  end

  private

  def format_suggestions(suggestions)
    suggestions.map{|s| {id: s['place_id'], text: s['text']}}
  end
end
