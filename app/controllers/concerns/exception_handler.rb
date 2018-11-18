# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # Handle all exceptions
    # rescue_from StandardError,                      with: :server_error!
    rescue_from JWT::DecodeError,                   with: :jwt_decode_error!
    rescue_from JWT::VerificationError,             with: :jwt_verification_error!
    rescue_from JWT::ExpiredSignature,              with: :jwt_expired_signature!
    rescue_from Consul::Powerless,                  with: :consul_powerless!
    rescue_from ActiveRecord::RecordNotFound,       with: :record_not_found!
    rescue_from CustomException::AuthUserNotFound,  with: :auth_user_not_found!
  end

  # The message of record not found, can be customized by override it to the controllers
  def record_not_found_message
    resource_name&.present? ? "#{resource_name&.singularize&.titleize} not found" : 'Record not found'
  end

  protected

  # Handle Consul::Powerless
  def consul_powerless!
    render_forbidden
  end

  # Handle ActiveRecord::RecordNotFound
  def record_not_found!
    render_not_found(error: record_not_found_message)
  end

  # Handle CustomException::AuthUserNotFound
  def auth_user_not_found!
    render_unauthorized(error: 'Authorizated user not exist')
  end

  # Handle JWT::VerificationError
  def jwt_verification_error!
    render_unauthorized(error: 'Invalid session token')
  end

  # Handle JWT::DecodeError
  def jwt_decode_error!
    render_unauthorized(error: 'Error with decoding session token')
  end

  # Handle JWT::ExpiredSignature
  def jwt_expired_signature!
    render_unauthorized(error: 'Your session token is expired')
  end

  # Handle all types of errors
  def server_error!(err)
    render_error(error: err.message)
  end
end
