json.array! @trips.each do |trip|
  json.id trip.id

  json.trip do
    json.name trip.name
    json.description trip.description
    json.created_at trip.created_at
  end
end