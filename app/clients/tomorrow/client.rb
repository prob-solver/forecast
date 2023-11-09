module Tomorrow
  class Client
    include HTTParty

    base_uri 'api.tomorrow.io'
    API_KEY = ENV.fetch('TOMORROW_API_KEY')

    def self.forecast(zip)
      self.get("/v4/weather/forecast", query(location: zip))
    end

    def self.query(query_hash={})
      {
        query: query_hash.merge(apikey: API_KEY)
      }
    end
    private_class_method :query

  end
end