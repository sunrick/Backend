class TripsController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :update, :show_all]
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

    # get places data
    self.set_duration_time(legs)
    self.get_places_data(legs)

    # create trip
    @trip = current_user.trips.create( name: params[:name] )
    # create origin
    @trip.places.create( user_id: current_user.id, address: @origin[:address], 
                    latitude: @origin[:latitude], longitude: @origin[:longitude],
                    place_type: "origin" )

    # create waypoints
    @waypoints.each do |waypoint|
      @trip.places.create( user_id: current_user.id, address: waypoint[:address], 
                    latitude: waypoint[:latitude], longitude: waypoint[:longitude],
                    place_type: "waypoint" )
    end
    # create destination
    @trip.places.create( user_id: current_user.id, address: @destination[:address], 
                    latitude: @destination[:latitude], longitude: @destination[:longitude],
                    place_type: "destination" )
    render 'create.json.jbuilder'
  end

  def show_all
    @trips = current_user.trips.all
    render 'trips.json.jbuilder'
  end

  def show
    # method checks google and updates the order
    @trip = current_user.trips.find(params[:id])
    @origin = @trip.places.find_by(place_type: "origin")
    @waypoints = @trip.places.where(place_type: "waypoint").pluck(:address)
    @waypoints = self.to_string(@waypoints)
    @destination = @trip.places.find_by(place_type: "destination")

    @options = { query: { origin: @origin.address, destination: @destination.address, 
                          waypoints: "optimize:true#{@waypoints}"}, units: "imperial" }
    @response = HTTParty.get(BASE_URL,@options)

    legs = @response['routes'][0]['legs']

    self.set_duration_time(legs)
    self.get_places_data(legs)

    render 'create.json.jbuilder'
  end

  def update
    places = [ params[:place1], params[:place2], params[:place3]]
    places = self.to_string(places)

    @options = { query: { origin: params[:origin], destination: params[:destination], 
                          waypoints: "optimize:true#{places}"}, units: "imperial" }
    @response = HTTParty.get(BASE_URL,@options)

    legs = @response['routes'][0]['legs']

    # get places data
    self.set_duration_time(legs)
    self.get_places_data(legs)

    @trip = current_user.trips.find(params[:id])
    
    # update origin
    @trip.places.find_by(place_type: 'origin').update( address: @origin[:address], 
                    latitude: @origin[:latitude], longitude: @origin[:longitude])
    # update destination
    @trip.places.find_by(place_type: 'destination').update( address: @destination[:address], 
                latitude: @destination[:latitude], longitude: @destination[:longitude])

    # update waypoints
    waypoints = @trip.places.where(place_type: 'waypoint')
    waypoints.each do |waypoint|
      # @waypoint is new waypoint
      waypoint_update = @waypoints.first
      binding.pry
      @trip.places.find_by(place_type: 'waypoint')
                    .update( address: waypoint_update[:address], 
                           latitude: waypoint_update[:latitude], 
                           longitude: waypoint_update[:longitude] )

      # delete first waypoint
      if !@waypoint.nil?
        @waypoint.shift
      end
    end
    render 'create.json.jbuilder'
  end

  protected

  def to_string(places)
    places.map { |place| '|'+place }.join
  end

  def set_duration_time(legs)
    @distance = 0
    @duration = 0
    legs.each do |leg|
      @distance += leg['distance']['value']
      @duration += leg['duration']['value']
    end
  end

  def get_places_data(legs)
    @origin = {
      address: legs.first['start_address'],
      latitude: legs.first['start_location']['lat'],
      longitude: legs.first['start_location']['lng']
    }
    @waypoints = []
    legs.each do |leg| 
      result = {
        address: leg['start_address'],
        latitude: leg['start_location']['lat'],
        longitude: leg['start_location']['lng']
      }
      @waypoints << result
    end
    # Get rid of first address which is origin
    @waypoints.shift
    @destination = {
      address: legs.last['end_address'],
      latitude: legs.last['end_location']['lat'],
      longitude: legs.last['end_location']['lng']
    }
    @destination
  end

end