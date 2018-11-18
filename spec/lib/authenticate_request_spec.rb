# frozen_string_literal: true

require 'rails_helper'

describe AuthenticateRequest do
  before(:all) do
    @user = create(:user)
    @token = JsonWebToken.encode(@user.jwt_payload)
  end

  describe '.get' do
    it 'return hash with user object if user exist and token is valid' do
      auth = AuthenticateRequest.get(User, @token)
      expect(auth).to include(:user)
      expect(auth[:user]).to eq(@user)
    end

    it 'raise CustomException::AuthUserNotFound if authenticated user not found or deleted' do
      @user.destroy
      expect do
        AuthenticateRequest.get(User, @token)
      end.to raise_error(CustomException::AuthUserNotFound)
    end
  end
end
