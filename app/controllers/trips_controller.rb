class TripsController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :update, :show_all]
  include HTTParty
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?"

  def create
    ## FOR SOME REASON DOESN'T REQUIRE API KEY
    waypoints = [ params[:place1], params[:place2], params[:place3], 
                  params[:place4], params[:place5], params[:place6],
                  params[:place7], params[:place8]]
    waypoints = waypoints.compact
    waypoints = self.to_string(waypoints)
    legs = self.google_query(params[:origin],params[:destination], waypoints, params[:mode])
    if !legs.nil?
      # data
      @duration = self.get_duration(legs)
      @distance = self.get_distance(legs)
      @origin = self.get_origin_data(legs)
      @waypoints = self.get_waypoints_data(legs)
      @destination = self.get_destination_data(legs)

      # create trip
      @trip = current_user.trips.create( name: params[:name], description: params[:description] )
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
    else
      render json: { message: "#{@error_message} #{@no_results}"},
              status: :unprocessable_entity
    end
  end

  def show_all
    @trips = current_user.trips.all
    render 'trips.json.jbuilder'
  end

  def show
    # method checks google and updates the order
    @trip = current_user.trips.find(params[:id])
    origin = @trip.places.find_by(place_type: "origin").address
    waypoints = @trip.places.where(place_type: "waypoint").pluck(:address)
    waypoints = self.to_string(waypoints)
    destination = @trip.places.find_by(place_type: "destination").address

    legs = self.google_query(origin, destination, waypoints, params[:mode])

    # data
    @duration = self.get_duration(legs)
    @distance = self.get_distance(legs)
    @origin = self.get_origin_data(legs)
    @waypoints = self.get_waypoints_data(legs)
    @destination = self.get_destination_data(legs)

    render 'create.json.jbuilder'
  end

  def update
    waypoints = [ params[:place1], params[:place2], params[:place3], 
                  params[:place4], params[:place5], params[:place6],
                  params[:place7], params[:place8]]
    waypoints = waypoints.compact
    waypoints = self.to_string(waypoints)

    legs = self.google_query(params[:origin],params[:destination], waypoints, mode)

    if !legs.nil?
      # data
      @duration = self.get_duration(legs)
      @distance = self.get_distance(legs)
      @origin = self.get_origin_data(legs)
      @waypoints = self.get_waypoints_data(legs)
      @destination = self.get_destination_data(legs)

      @trip = current_user.trips.find(params[:id])

      #destroy all places for the trip
      @trip.places.destroy_all

      @trip.update(name: params[:name], description: params[:description])

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
    else
      render json: { message: "#{@error_message} #{@no_results}"},
        status: :unprocessable_entity
    end
  end

  protected

  def to_string(places)
    places.map { |place| '|'+place }.join
  end

  def get_duration(legs)
    duration = 0
    legs.each do |leg|
      duration += leg['duration']['value']
    end
    @seconds = duration
    duration = self.time_calculation(duration)
    duration
  end

  def get_distance(legs)
    distance = 0
    legs.each do |leg|
      distance += leg['distance']['value']
    end
    distance = self.distance_calc(distance)
    distance
  end

  def google_query(origin, destination, waypoints, mode)
    options = { query: {  origin: origin, destination: destination, 
                          waypoints: "optimize:true#{waypoints}", 
                          units: "imperial", mode: mode 
                          } }
    response = HTTParty.get(BASE_URL,options)
    if response['error_message'] || response['status'] == "ZERO_RESULTS"
      @error_message = response['error_message']
      @no_results = response['status'] + " Check your addresses"
      result = nil
    else
      result = response['routes'][0]['legs']
    end
    result
  end

  def get_origin_data(legs)
    {
      address: legs.first['start_address'],
      latitude: legs.first['start_location']['lat'],
      longitude: legs.first['start_location']['lng']
    }
  end

  def get_waypoints_data(legs)
    waypoints = []
    legs.each do |leg| 
      data = {
        address: leg['start_address'],
        latitude: leg['start_location']['lat'],
        longitude: leg['start_location']['lng']
      }
      waypoints << data
    end
    # Get rid of first address which is origin
    waypoints.shift
    waypoints
  end

  def get_destination_data(legs)
    {
      address: legs.last['end_address'],
      latitude: legs.last['end_location']['lat'],
      longitude: legs.last['end_location']['lng']
    }
  end

  def time_calculation(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60) % 24
    days = total_seconds / (60 * 60 * 24) % 7
    weeks = total_seconds / (60 * 60 * 24 * 7)
    format("%02d weeks, %02d days, %02d hrs, %02d mins, %02d secs", weeks, days, hours, minutes, seconds)
  end

  def distance_calc(distance)
    distance = (distance.to_f/1609.34.to_f).round(2)
    distance
  end

end