json.id @trip.id

json.trip do
  json.name @trip.name
  json.distance @distance
  json.duration @duration
end

json.route do
  json.origin @origin
  json.waypoints do
    json.array! @waypoints
  end
  json.destination @destination
end