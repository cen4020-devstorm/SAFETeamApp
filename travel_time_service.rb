require "httparty"
require "json"

class TravelTimeService
  GOOGLE_API_KEY = "" 

  # Function to get latitude/longitude from an address
  def self.get_coordinates(address)
    return { error: "Invalid address" } if address.nil? || address.strip.empty?

    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode_www_form_component(address)}&key=#{GOOGLE_API_KEY}"
    
    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    puts "📍 Geocode API Response: #{data.inspect}" # Debugging log

    if data["status"] == "OK"
      location = data["results"][0]["geometry"]["location"]
      { lat: location["lat"], lng: location["lng"] }
    else
      { error: "Failed to get coordinates for #{address}: #{data['status']}" }
    end
  end

  # Function to get travel time using Google Routes API
  def self.get_travel_time(origin_address, destination_address)
    origin_coords = get_coordinates(origin_address)
    destination_coords = get_coordinates(destination_address)

    return origin_coords if origin_coords[:error] # If error, return message
    return destination_coords if destination_coords[:error]

    url = "https://routes.googleapis.com/directions/v2:computeRoutes?key=#{GOOGLE_API_KEY}"

    headers = {
      "Content-Type" => "application/json",
      "X-Goog-Api-Key" => GOOGLE_API_KEY,
      "X-Goog-FieldMask" => "routes.duration,routes.distanceMeters"
    }

    body = {
      "origin" => { "location" => { "latLng" => { "latitude" => origin_coords[:lat], "longitude" => origin_coords[:lng] } } },
      "destination" => { "location" => { "latLng" => { "latitude" => destination_coords[:lat], "longitude" => destination_coords[:lng] } } },
      "travelMode" => "DRIVE",
      "computeAlternativeRoutes" => false
    }.to_json

    response = HTTParty.post(url, headers: headers, body: body)
    data = JSON.parse(response.body)

    puts "🚗 Routes API Response: #{data.inspect}" 

    if data["routes"] && data["routes"].any?
      duration_text = parse_duration(data["routes"][0]["duration"])
      distance_km = (data["routes"][0]["distanceMeters"].to_f / 1000).round(2)

      { duration: duration_text, distance: "#{distance_km} km" }
    else
      { error: data.dig("error", "message") || "Failed to retrieve travel time" }
    end
  end

  # Function to parse duration
  def self.parse_duration(duration_value)
    return "N/A" if duration_value.nil?

    duration_seconds = duration_value.to_i
    minutes = (duration_seconds / 60).round
    hours = (minutes / 60).floor
    remaining_minutes = minutes % 60

    if hours > 0
      "#{hours} hr #{remaining_minutes} min"
    else
      "#{minutes} min"
    end
  end
end

