# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Helpers
  include JwtHelper
  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
  # rescue_from StandardError, with: :handle_standard_error

  private

  def authorize_request
    token = request.headers['Authorization']
    if token.present?
      decoded_token = decode_token(token)
      return render json: { error: 'Invalid token' }, status: :unauthorized if decoded_token.nil?

      @current_user = UserBlock::User.find(decoded_token['user_id'])
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

  # General error response
  def render_error(exception, status:, custom_message: nil)
    file_name, line_number = exception.backtrace.first.split(':')
    render json: {
      error: custom_message || 'Something went wrong',
      exception: exception.message,
      trace: "#{file_name}:#{line_number}"
    }, status: status || status_message(status)
  end

  # Specific exception handlers
  def handle_not_found(exception)
    render_error(exception, status: :not_found, custom_message: 'Resource not found')
    log_exception(exception)
  end

  def handle_unprocessable_entity(exception)
    render_error(exception, status: :unprocessable_entity, custom_message: 'Invalid record')
  end

  def handle_standard_error(exception, custom_message: nil)
    render_error(exception, status: :unprocessable_entity, custom_message: custom_message)
    log_exception(exception)
  end

  # Utility to map status codes to default messages
  def status_message(status)
    Rack::Utils::HTTP_STATUS_CODES[Rack::Utils.status_code(status)]
  end

  # Log exceptions for debugging
  def log_exception(exception)
    Rails.logger.error "Exception: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
  end
end
