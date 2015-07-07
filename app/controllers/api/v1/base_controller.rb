class Api::V1::BaseController < ActionController::Base
  before_filter :permit_parameters

  #  We use this filter to allow the sending of any size of parameters
  def permit_parameters
    params.permit!
  end

  def self.error_message( api_params = nil, object = nil )
    return {} if api_params.nil? && object.nil?
    return {status: 'ERROR', code: 'TOO_FEW_PARAMETERS', fallback_msg: 'EMPTY OBJECT PARAMETER'} if api_params && object.nil?
    return {status: 'ERROR', code: 'TOO_FEW_PARAMETERS', fallback_msg: object.message} if api_params.nil? && object
    return api_params.merge({status: 'ERROR', code: 'WRONG_DATA', fallback_msg: object.message}) if api_params && object
  end

  def self.success_message(api_params = nil, message = nil)
    return {} if api_params.nil? && message.nil?
    return {status: 'OK', code: 'OK', fallback_msg: 'EMPTY MESSAGE PARAMETER'} if api_params && message.nil?
    return {status: 'OK', code: 'OK', fallback_msg: message} if api_params.nil? && message
    return api_params.merge({status: 'OK', code: 'OK', fallback_msg: message}) if api_params && message
  end

end

