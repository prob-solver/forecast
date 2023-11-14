class TomorrowForecast
  include ActiveModel::Model

  attr_accessor :data, :fetch_from, :postal_code
end
