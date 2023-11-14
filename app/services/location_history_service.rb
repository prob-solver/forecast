class LocationHistoryService
  HISTORY_MAX = 10

  def self.add(session, location)
    session[:location_histories] ||= []

    return if session[:location_histories].any? { |h| h['location_id'] == location.id }

    session[:location_histories].pop if session[:location_histories].size > HISTORY_MAX

    session[:location_histories].unshift(
      location.as_json_for_cookie
    )
  end

  def self.find_all(session)
    session[:location_histories] || []
  end
end
