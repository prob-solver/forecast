class TomorrowForecast
  include ActiveModel::Model

  attr_accessor :data, :fetch_from

  def current_temp
    @data.dig('timelines', 'minutely', 0, 'temperature')
  end

  def today_temp_high
    @data.dig('timelines', 'daily', 0, 'values', 'temperatureMax')
  end

  def today_temp_low
    @data.dig('timelines', 'daily', 0, 'values', 'temperatureApparentMin')
  end
end