require "http"
require "json"
require "dotenv/load"
# Write your soltuion here!
pp "Hello!"
pp "Where are you located?"

user_location = "Chicago"

# user_location = gets.chomp

pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")
p maps_url

require "http"

resp = HTTP.get(maps_url)

raw_response = resp.to_s

require "json"

parsed_response = JSON.parse(raw_response)

pp parsed_response.keys
