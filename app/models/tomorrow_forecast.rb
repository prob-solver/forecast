class TomorrowForecast
  include ActiveModel::Model

  attr_accessor :data, :fetch_from

  def minutely_timelines
    @data.dig('timelines', 'minutely')
  end

  def daily_timelines
    @data.dig('timelines', 'daily')
  end

  def current_temp
    minutely_timelines.dig(0, 'temperature')
  end

  def today_temp_high
    daily_timelines.dig(0, 'values', 'temperatureMax')
  end

  def today_temp_low
    daily_timelines.dig(0, 'values', 'temperatureApparentMin')
  end
end