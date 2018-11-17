# frozen_string_literal: true

class AuthenticateRequest
  attr_reader :token

  def self.get(model, token = {})
    new(model, token).call
  end

  def initialize(model, token = {})
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
    # memoize user object
    @user ||= @model.find(decoded_auth_token[:id]) if decoded_auth_token
    # handle user not found
    # rescue ActiveRecord::RecordNotFound
    #   # raise custom error
    #   raise(CustomException::AuthUserNotFound, 'Authorizated user not exist')
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(auth_token)
  end

  # check for auth_token in `Authorization` header
  def auth_token
    return token if token.present?

    # raise(CustomException::MissingToken, 'token is missing')
  end
end
