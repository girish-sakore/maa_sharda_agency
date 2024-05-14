# frozen_string_literal: true
class PublicApisController < ApplicationController
  def types
    render json: { account_types: account_types }
  end

  private

  def account_types
    [ "admin", "caller", "executive" ]
  end
end