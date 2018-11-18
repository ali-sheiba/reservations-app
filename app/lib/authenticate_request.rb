# frozen_string_literal: true

class AuthenticateRequest
  attr_reader :token

  def self.get(model, token)
    new(model, token).call
  end

  def initialize(model, token)
    @token = token
    @model = model
  end

  # Service entry point - return valid user object
  def call
    {
      user: user
    }
  end

  private

  def user
    # check if user is in the database
    @user ||= @model.find(decoded_auth_token[:id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound
    # raise custom error if user not found
    raise(CustomException::AuthUserNotFound)
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(token)
  end
end
