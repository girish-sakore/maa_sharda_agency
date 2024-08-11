# frozen_string_literal: true
class PublicApisController < ApplicationController
  skip_before_action :authorize_request

  def types
    render json: { account_types: account_types }, status: :ok
  end

  private

  def account_types
    [ "admin", "caller", "executive" ]
  end
end