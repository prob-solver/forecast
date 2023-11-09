class ForecastService

  class InvalidLocation < StandardError; end
  class AmbitiousLocation < StandardError; end
  class ForestBadRequest < StandardError; end

  attr_reader :location
  attr_accessor :fetch_from # value=remote if fetch from remote, otherwise fetch from cache

  def initialize(location)
    @location = location
  end

  def get_forecast
    forest_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      get_remote_forecast
    end

    forest_data.merge(fetch_from: fetch_from)
  end

  private

  def fetch_from
    @fetch_from || 'cache'
  end

  def cache_key
    "forecast/#{zip}"
  end

  def get_remote_forecast
    resp = Tomorrow::Client.new(zip).forecast
    if resp.success?
      fetch_from = "remote"
      TomorrowForecast.new(resp.to_hash)
    else
      raise ForestBadRequest, {code: resp.code, message: resp.message}.as_json
    end
  end

  def zip
    results = Geocoder.search(location)
    postal_codes = results.map(&:postal_code).compact
    case postal_codes.size
    when 0
      raise InvalidLocation, 'Could not find zip code from address'
    when 1
      postal_codes.first
    else
      raise AmbitiousLocation, 'Multiple zip codes are found from location'
    end
  end
end