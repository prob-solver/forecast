module Tomorrow
  class Client
    include HTTParty

    base_uri 'api.tomorrow.io'
    API_KEY = ENV.fetch('TOMORROW_API_KEY')
    TEMPERATURE_UNIT = 'imperial' # could be metric

    def self.forecast(zip)
      self.get("/v4/weather/forecast", query(location: zip))
    end

    def self.query(query_hash={})
      {
        query: query_hash.merge(default_params)
      }
    end
    private_class_method :query

    def self.default_params
      {apikey: API_KEY, units: TEMPERATURE_UNIT}
    end

  end
end