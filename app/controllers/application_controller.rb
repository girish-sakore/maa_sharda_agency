# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JwtHelper

  private

  def authorize_request
    token = request.headers['Authorization']
    if token.present?
      begin
        decoded_token = decode_token(token)
        @current_user = User.find(decoded_token['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :unauthorized
    end
  end
end
