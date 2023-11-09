class ForecastService

  class InvalidLocation < StandardError; end
  class AmbitiousLocation < StandardError; end
  class ForestBadRequest < StandardError; end

  def initialize(location)
    @location = location
  end

  def get_forecast
    # reset fetch from
    fetch_from = "cache"
    forest_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      fetch_from = "remote"
      get_remote_forecast
    end

    TomorrowForecast.new(fetch_from: fetch_from, data: forest_data)
  end

  private

  attr_reader :location

  def cache_key
    "forecast/#{location.postal_code}"
  end

  def get_remote_forecast
    resp = Tomorrow::Client.forecast(location.postal_code)
    if resp.success?
      resp.to_hash
    else
      raise ForestBadRequest, {service: "tomorrow", code: resp.code, message: resp.message}.as_json
    end
  end
end