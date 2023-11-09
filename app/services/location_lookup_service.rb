# Auto complete location, let users choose
class LocationLookupService

  class BadLocation < StandardError; end

  def self.search(location)
    Geocoder.search(location)
  end

  def self.suggestions(location)
    results = search(location)
    remove_duplications!(results)
    results.map(&:address)
  end

  def self.get_full_address(location, depth = 0)
    results = search(location)

    if results.first && results.first.postal_code
      # actually should return multiple address results to let customer choose
      results.first.address
    elsif results.first
      results.first.postal_code
    end
  end

  def self.remove_duplications!(geocoder_results)
    unique_addresses = {}
    geocoder_results.delete_if do |result|
      if unique_addresses[result.address] == 1
        true
      else
        unique_addresses[result.address] = 1
        false
      end
    end
  end

end