class Location
  include ActiveModel::Model

  attr_accessor :place, :id

  delegate :postal_code, to: :place
end