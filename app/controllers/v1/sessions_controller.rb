# frozen_string_literal: true

class V1::SessionsController < ApplicationController
  def create
    user = User.login(session_params)
    if user
      render_create(
        user: user,
        token: JsonWebToken.encode(user.jwt_payload)
      )
    else
      render_error(error: 'invalid email or password')
    end
  rescue ArgumentError => e
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
