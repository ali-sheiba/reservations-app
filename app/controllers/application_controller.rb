# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonResponders
  include ExceptionHandler
  include Consul::Controller

  before_action :authenticate_request!

  require_power_check

  attr_reader :current_user

  current_power do
    Power.new(current_user)
  end

  private

  def authenticate_request!
    return unless request.headers['Authorization'].present?

    @token ||= AuthenticateRequest.get(User, request.headers['Authorization'].split(' ').last)
    @current_user = @token[:user]
  end
end
