json.id @trip.id

json.trip do
  json.name @trip.name
  json.description @trip.description
  json.distance "#{@distance} miles"
  json.duration @duration
end

json.route do
  json.origin @origin
  json.waypoints do
    json.array! @waypoints
  end
  json.destination @destination
end