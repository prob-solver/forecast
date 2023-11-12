class Location
  include ActiveModel::Model

  attr_accessor :place, :id

  delegate :postal_code, to: :place

  def as_json_for_cookie
    {
      id: id,
      label: place.label
    }
  end
end