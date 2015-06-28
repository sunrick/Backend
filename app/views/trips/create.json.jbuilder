json.id @trip.id

json.trip do
  json.name @trip.name
  json.description @trip.description
  json.distance "#{(@distance.to_f/5280.to_f).round(2)} miles"
  json.duration Time.at(@duration).utc.strftime("%H hours, %M minutes, %S seconds")
end

json.route do
  json.origin @origin
  json.waypoints do
    json.array! @waypoints
  end
  json.destination @destination
end