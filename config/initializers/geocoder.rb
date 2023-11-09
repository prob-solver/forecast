# credentials = Aws::Credentials.new(
#   ENV.fetch('AWS_ACCESS_KEY_ID'),
#   ENV.fetch('AWS_SECRET_ACCESS_KEY')
# )
#
#
# client = Aws::LocationService::Client.new(
#   region: "us-east-2",
#   credentials: credentials
# )
#
#
# pp client.search_place_index_for_suggestions(
#   index_name: "explore.place.Esri",
#   key: ENV['AWS_LOCATION_API_KEY'],
#   text: "round rock"
# )

Geocoder.configure(
  lookup: :amazon_location_service,
  amazon_location_service: {
    index_name: ENV.fetch('AWS_LOCATION_INDEX_NAME'),
    api_key: {
      region: 'us-east-2',
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    }
  }
)