class Api::V1::LocationsController < ApplicationController

  def suggestions
    suggestions = LocationSuggestionService.search_place_index_for_suggestions(params[:query])
    render json: format_suggestions(suggestions)
  end

  def show
    location = LocationSuggestionService.get_place_with_postal_code(params[:id])
    render json: location
  end

  private

  def format_suggestions(suggestions)
    suggestions.map{|s| {id: s['place_id'], text: s['text']}}
  end
end
