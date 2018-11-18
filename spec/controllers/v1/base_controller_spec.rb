# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BaseController, type: :controller do
  controller do
    def index
      render json: { message: 'dump test' }
    end
  end

  before(:all) do
    @user = create(:user)
    @token = "Bearer #{JsonWebToken.encode(@user.jwt_payload)}"
  end

  it 'handle JWT::VerificationError' do
    controller.stub(:authenticate_request!) { raise JWT::VerificationError }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 401
    expect(json['error']).to eq 'Invalid session token'
  end

  it 'handle JWT::DecodeError' do
    controller.stub(:authenticate_request!) { raise JWT::DecodeError }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 401
    expect(json['error']).to eq 'Error with decoding session token'
  end

  it 'handle JWT::ExpiredSignature' do
    controller.stub(:authenticate_request!) { raise JWT::ExpiredSignature }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 401
    expect(json['error']).to eq 'Your session token is expired'
  end

  it 'handle Consul::Powerless' do
    controller.stub(:authenticate_request!) { raise Consul::Powerless }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 403
    expect(json['error']).to eq 'You are forbidden for this request'
  end

  it 'handle ActiveRecord::RecordNotFound' do
    controller.stub(:authenticate_request!) { raise ActiveRecord::RecordNotFound }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 404
    expect(json['error']).to eq 'Base not found'
  end

  it 'handle CustomException::AuthUserNotFound' do
    controller.stub(:authenticate_request!) { raise CustomException::AuthUserNotFound }

    @request.headers['Authorization'] = @token
    get :index
    expect(response).to have_http_status 401
    expect(json['error']).to eq 'Authorizated user not exist'
  end
end
