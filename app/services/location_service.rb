class LocationService
  class LocationNotFound < StandardError; end
  class InvalidQueryString < StandardError; end

  AWS_LOCATION_API_KEY = ENV['AWS_LOCATION_API_KEY']
  AWS_LOCATION_INDEX_NAME = ENV['AWS_LOCATION_INDEX_NAME']
  AWS_REGION = 'us-east-2'
  MAX_RESULTS = 10

  # Get address suggestions from AWS Location Service
  # @Return Array(struct Aws::LocationService::Types::SearchForSuggestionsResult)
  def self.search_suggestions(query_string)
    validate_suggestion_query!(query_string)
    resp = client.search_place_index_for_suggestions(
      opts(text: query_string, max_results: MAX_RESULTS)
    )
    resp.results
  end

  def self.find_location!(place_id)
    place = get_place(place_id)

    raise LocationNotFound, "location not found with id=#{place_id}" if place.blank?

    if place.postal_code.blank?
      resp = client.search_place_index_for_position opts(position: place.geometry.point)
      place.postal_code = resp.results.first.place.postal_code
    end

    Location.new(place: place, id: place_id)
  end

  def self.get_place(place_id)
    result = client.get_place(opts(place_id: place_id))
    result.place
  rescue Aws::LocationService::Errors::ValidationException => e
    # invalid place id
    nil
  end

  def self.validate_suggestion_query!(query_string)
    return unless query_string.blank?

    raise InvalidQueryString, 'Query must have length at least 1'
  end

  def self.opts(options = {})
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
      region: AWS_REGION,
      credentials: credentials
    )
  end
end
