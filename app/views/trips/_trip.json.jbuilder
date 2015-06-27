json.id "placeholder (should be number)"

json.trip do
  json.name "placeholder"
  json.distance @distance
  json.duration @duration
end

json.route do
  json.array! @places
end