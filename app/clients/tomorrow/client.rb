module Tomorrow
  class Client
    include HTTParty

    base_uri 'api.tomorrow.io'
    API_KEY = ENV.fetch('TOMORROW_API_KEY')

    def initialize(zip)
      @zip = zip
    end

    def forecast
      self.class.get("/v4/weather/forecast", query(location: zip))
    end

    private

    attr_reader :zip

    def query(query_hash={})
      {
        query: query_hash.merge(apikey: API_KEY)
      }
    end
  end
end