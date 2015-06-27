json.id @trip.id

json.trip do
  json.name @trip.name
  json.distance @distance
  json.duration @duration
end

json.route do
  json.origin do
    json.address @origin.address
    json.latitude @origin.latitude
    json.longitude @origin.longitude
  end
  json.waypoints do
    json.array! @waypoints do |waypoint|
      json.address waypoint.address
      json.latitude waypoint.latitude
      json.longitude waypoint.longitude
    end
  end
  json.destination do
    json.address @destination.address
    json.latitude @destination.latitude
    json.longitude @destination.longitude
  end
end