# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Helpers
  include JwtHelper
  before_action :authorize_request

  private

  def authorize_request
    token = request.headers['Authorization']
    if token.present?
      begin
        decoded_token = decode_token(token)
        @current_user = UserBlock::User.find(decoded_token['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :unauthorized
    end
  end

  def not_admin?
    return permission_denied unless @current_user.is_admin?
  end

  def permission_denied
    return render json: { error: 'No permission to access the resource.' }, status: :unauthorized
  end
end
