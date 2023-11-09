# Auto complete location, let users choose
class LocationLookupService

  def self.search(location)
    Geocoder.search(location)
  end
end