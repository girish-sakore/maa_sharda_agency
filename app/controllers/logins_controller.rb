# frozen_string_literal: true
class LoginsController < ApplicationController
  include JwtHelper

  def create
    user = UserBlock::User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      token = encode_token(payload)
      render json: { id: user.id, type: user.type, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

end