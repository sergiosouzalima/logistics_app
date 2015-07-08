class Api::V1::RoutesController < Api::V1::BaseController
  respond_to :json

  def create_map
    # under construction
  end

  def get_route
    result_message = Api::V1::BaseController.find_the_cheapest_route(
      params[:map_name],
      params[:origin], params[:destination],
      params[:fuel_autonomy], params[:fuel_price] )
    if result_message.nil? || result_message.is_a?(String)
      result = Api::V1::BaseController.error_message( {name:params[:map_name]}, result_message )
    else
      result = Api::V1::BaseController.success_message( {name:params[:map_name]}, result_message )
    end
    respond_with result
  end

end

