class LocationSuggestionService

  class LocationNotFound < StandardError; end

  AWS_LOCATION_API_KEY = ENV['AWS_LOCATION_API_KEY']
  AWS_LOCATION_INDEX_NAME = ENV['AWS_LOCATION_INDEX_NAME']
  MAX_RESULTS = 10

  # Get address suggestions from AWS Location Service
  # @Return Array(struct Aws::LocationService::Types::SearchForSuggestionsResult)
  def self.search_suggestions(query_string)
    resp = client.search_place_index_for_suggestions(
      opts(text: query_string, max_results: MAX_RESULTS)
    )
    resp.results
  end

  def self.find_location!(place_id)
    place = get_place(place_id)

    if place.blank?
      raise LocationNotFound, "location not found with id=#{place_id}"
    end

    if place.postal_code.blank?
      resp = client.search_place_index_for_position opts(position: place.geometry.point)
      place.postal_code = resp.results.first.place.postal_code
    end

    Location.new(place: place, id: place_id)
  end


  def self.get_place(place_id)
    begin
      result = client.get_place(opts(place_id: place_id))
      result.place
    rescue Aws::LocationService::Errors::ValidationException => e
      # invalid place id
      return nil
    end
  end

  private

  def self.opts(options={})
    options.merge(
      index_name: AWS_LOCATION_INDEX_NAME,
      key: AWS_LOCATION_API_KEY
    )
  end

  def self.credentials
    @credentials ||= Aws::Credentials.new(
      ENV.fetch('AWS_ACCESS_KEY_ID'),
      ENV.fetch('AWS_SECRET_ACCESS_KEY')
    )
  end

  def self.client
    @client ||= Aws::LocationService::Client.new(
      region: "us-east-2",
      credentials: credentials
    )
  end
end