class Api::V1::BaseController < ActionController::Base
  respond_to :json
  before_filter :permit_parameters

  #  We use this filter to allow the sending of any size of parameters
  def permit_parameters
    params.permit!
  end

  def self.create_map_routes( map_name, routes )
    # parameters validation
    return "invalid parameter" if map_name.nil? || routes.nil?
    return "invalid parameter. 'Routes' is empty" if routes.empty?
    # check elements in routes array
    elements_in_hash_qty_error = false
    routes.each{ |e| elements_in_hash_qty_error = e.keys.size != 3 unless elements_in_hash_qty_error}
    return "invalid parameter. 'Routes' must be a 3 elements hash" if elements_in_hash_qty_error
    # check if all elements in routes array, has a value
    elements_in_hash_value_error = false
    routes.each do |e|
      e.each do |key,value|
        elements_in_hash_value_error = value.nil? unless elements_in_hash_value_error
        if value.is_a? String
          elements_in_hash_value_error = value.empty? unless elements_in_hash_value_error
        end
      end
    end
    return "invalid parameter. All elements in 'Routes' must have a value" if elements_in_hash_value_error
    #
    # create map and routes
    #
    error = false
    message = "Map and routes created successfully"
    begin
      map = Map.find_or_create_by(name: map_name)
      Route.find_or_create_by( map_id: map.id )
      routes.each do |r|
        Route.create_with(distance: r[:distance]).
          find_or_create_by(origin_point: r[:origin], destination_point: r[:destination], map_id: map.id)
      end
    rescue
      error = true
    end
    message = "Error creating map and/or routes" if error
    return message
  end


  def self.find_the_cheapest_route( map_name, origin, destination, fuel_autonomy, fuel_price )
    # parameters validation
    return "invalid parameter"  if map_name.nil? ||  origin.nil? || destination.nil? || fuel_autonomy.nil? || fuel_price.nil?
    return "invalid parameter. fuel_autonomy is 0" if fuel_autonomy.to_f.zero?
    map_id = Map.where( name: map_name ).pluck( :id )[0]
    return "map_name not found" unless map_id
    route = Route.where( origin_point: origin, map_id: map_id )
    return "origin route not found" if route.empty?
    route = Route.where( destination_point: destination, map_id: map_id )
    return "destination route not found" if route.empty?
    #
    # find the cheapest route algorithm begins here....
    #
    first_iteration   = true
    destination_found = false
    current_point     = origin
    path              = []
    loop do
      r = Route.where( origin_point: current_point, destination_point: destination, map_id: map_id ).select( :destination_point, :distance )[0]
      if r.nil?
        r = Route.where( origin_point: current_point, map_id: map_id ).select( :destination_point, :distance ).first
      end
      break if r.nil?
      cur_dest, cur_distance = r[:destination_point], r[:distance]
      path << [current_point, cur_dest, cur_distance]
      destination_found = cur_dest == destination
      break if destination_found
      current_point = cur_dest
    end
    # distances sum
    dist_sum    = path.inject(0){ |sum,e| sum + e[2] }
    # final cost calculation
    total_cost  = (fuel_price.to_f / fuel_autonomy.to_f * dist_sum).round(2)
    # build final directions array
    directions = []
    path.each{ |e| directions << e[0] << e[1] }
    { "distance": dist_sum, "cost": total_cost, "directions": directions.uniq }
  end

  def self.error_message( api_params = nil, object = nil )
    return {} if api_params.nil? && object.nil?
    return {status: 'ERROR', code: 'TOO_FEW_PARAMETERS', fallback_msg: 'EMPTY OBJECT PARAMETER'} if api_params && object.nil?
    return {status: 'ERROR', code: 'TOO_FEW_PARAMETERS', fallback_msg: object} if api_params.nil? && object
    return api_params.merge({status: 'ERROR', code: 'WRONG_DATA', fallback_msg: object}) if api_params && object
  end

  def self.success_message(api_params = nil, message = nil)
    return {} if api_params.nil? && message.nil?
    return {status: 'OK', code: 'OK', fallback_msg: 'EMPTY MESSAGE PARAMETER'} if api_params && message.nil?
    return {status: 'OK', code: 'OK', fallback_msg: message} if api_params.nil? && message
    return api_params.merge({status: 'OK', code: 'OK', fallback_msg: message}) if api_params && message
  end

end

