# frozen_string_literal: true

class V1::SessionsController < ApplicationController
  power :sessions

  skip_before_action :authenticate_request!

  def create
    user = User.login(session_params)
    if user
      # return user object and JWT token on success login
      render_created(
        user: user,
        token: JsonWebToken.encode(user.jwt_payload)
      )
    else
      render_error(error: 'invalid email or password')
    end
  rescue ArgumentError => e
    # handle missing params
    render_unprocessable_entity(error: e.message)
  end

  private

  def session_params
    # permit the params and symbolize them to be used in login method
    params.permit(:email, :password)
          .to_h
          .symbolize_keys
  end
end
