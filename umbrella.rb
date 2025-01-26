require "http"
require "json"
require "dotenv/load"
# Write your soltuion here!
puts "Hello!"
puts "Where are you located?"

user_location = gets.chomp

# user_location = "Chicago"

puts user_location

# Take the lat/lng

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

require "http"

resp_maps = HTTP.get(maps_url)

raw_response_maps = resp_maps.to_s

require "json"

parsed_response_maps = JSON.parse(raw_response_maps)

maps_results = parsed_response_maps.fetch("results")

first_result = maps_results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

puts "Your coordinates are: " + latitude.to_s + " and " + longitude.to_s + "."

# Assemble the correct URL for the Pirate Weather API
weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + latitude.to_s + "," + longitude.to_s

# Get it, parse it, and dig out the current temperature
resp_weather = HTTP.get(weather_url)

raw_response_weather = resp_weather.to_s

require "json"

parsed_response_weather = JSON.parse(raw_response_weather)

weather_results = parsed_response_weather.fetch("currently")

temperature = weather_results.fetch("temperature")

puts "The weather is " + temperature.to_s + "."

# Parse the weather data and dig out the next hour summary
minutely_data = parsed_response_weather.fetch("minutely", nil) # Using nil as default if "minutely" doesn't exist
if minutely_data
  next_hour_summary = minutely_data.fetch("summary")
  puts "The weather for the next hour: " + next_hour_summary
else
  puts "No minutely weather data available."
end

# Parse the weather data and dig out the hourly data
hourly_data = parsed_response_weather.fetch("hourly", nil)
umbrella_needed = false # Flag to track if an umbrella is needed

if hourly_data
  hourly_forecast_array = hourly_data.fetch("data")

  # Get the forecast for the next twelve hours, skipping the current hour
  next_twelve_hours = hourly_forecast_array[1..12]

  next_twelve_hours.each do |hour|
    precip_probability = hour.fetch("precipProbability")

    # Check if the probability is greater than 10%
    if precip_probability > 0.1
      umbrella_needed = true # Set the flag to true if probability is greater than 10%
      break # Since we only need to know if it's greater once, we can exit the loop early
    end
  end

  if umbrella_needed
    puts "You might want to carry an umbrella!"
  else
    puts "You probably won't need an umbrella today."
  end
else
  pp "No hourly weather data available."
end
