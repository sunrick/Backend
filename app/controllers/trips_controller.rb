class TripsController < ApplicationController
  include HTTParty
  # base_uri "maps.googleapis.com/maps/api/directions/json"
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?"

  def create
    ## FOR SOME REASON DOESN'T REQUIRE API KEY
    places = [ params[:place1], params[:place2], params[:place3]]
    places = self.to_string(places)

    @options = { query: { origin: params[:origin], destination: params[:destination], 
                          waypoints: "optimize:true#{places}"}, units: "imperial" }
    @response = HTTParty.get(BASE_URL,@options)

    legs = @response['routes'][0]['legs']

    @distance = 0
    @duration = 0

    legs.each do |leg|
      @distance += leg['distance']['value'].to_i
      @duration += leg['duration']['value'].to_i
    end

    @places = []
    legs.each do |leg| 
      result = {
        address: leg['start_address'],
        latitude: leg['start_location']['lat'],
        longitude: leg['start_location']['lng']
      }
      @places << result
    end

    @destination = {
      address: legs.last['end_address'],
      latitude: legs.last['end_location']['lat'],
      longitude: legs.last['end_location']['lng']
    }

    @places << @destination

    render '_trip.json.jbuilder'
  end

  def show_all
  end

  def show
  end

  def update
  end

  protected

  def to_string(places)
    places.map { |place| '|'+place }.join
  end

end