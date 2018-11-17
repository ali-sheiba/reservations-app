# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # Handle all exceptions
    rescue_from StandardError,                      with: :server_error!
    rescue_from Consul::Powerless,                  with: :consul_powerless!
    rescue_from ActiveRecord::RecordNotFound,       with: :record_not_found!
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

  # Handle all types of errors
  def server_error!(err)
    render_error(error: err.message)
  end
end
