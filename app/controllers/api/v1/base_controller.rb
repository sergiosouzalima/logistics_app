class Api::V1::BaseController < ActionController::Base
  before_filter :permit_parameters

  #  We use this filter to allow the sending of any size of parameters
  def permit_parameters
    params.permit!
  end

  def self.find_the_cheapest_route( map_name, origin, destination, fuel_autonomy, fuel_price )
    return "invalid parameter"  if map_name.nil? ||  origin.nil? || destination.nil? || fuel_autonomy.nil? || fuel_price.nil?
    map_id = Map.where( name: map_name ).pluck( :id )[0]
    return "map_name not found" unless map_id
    route = Route.where( origin_point: origin, map_id: map_id )
    return "origin route not found" if route.empty?
    #
    # find the cheapest route algorithm begins here....
    #
    route = Route.where( origin_point: origin, map_id: map_id, destination_point: destination )
    return "destination route not found" if route.empty?
    distance          = route.pluck( :distance )[0]
    destination_point = route.pluck(:destination_point)[0]
    total_cost        = fuel_price.to_f / fuel_autonomy.to_f * distance.to_f
    { "distance": distance, "cost": total_cost, "directions": [origin, destination_point] }
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

