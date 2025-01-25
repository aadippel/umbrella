require "http"
require "json"
require "dotenv/load"
# Write your soltuion here!
pp "Hello!"
pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")

# user_location = "Chicago"

pp user_location

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

pp "Your coordinates are: " + latitude.to_s + " and " + longitude.to_s + "."

# Assemble the correct URL for the Pirate Weather API
weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + latitude.to_s + "," + longitude.to_s

# Get it, parse it, and dig out the current temperature
resp_weather = HTTP.get(weather_url)

raw_response_weather = resp_weather.to_s

require "json"

parsed_response_weather = JSON.parse(raw_response_weather)

weather_results = parsed_response_weather.fetch("results")

second_result = results.at(0)

#geo = second_result.fetch("geometry")

#loc = geo.fetch("location")

#latitude = loc.fetch("lat")
#longitude = loc.fetch("lng")

# pp "The weather is " + X.to_s + "."
