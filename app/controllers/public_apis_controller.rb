# frozen_string_literal: true
class PublicApisController < ApplicationController
  skip_before_action :authorize_request

  def types
    render json: { account_types: account_types }, status: :ok
  end

  def get_searchable_columns
    searchable_columns = AllocationDraft.column_names.reject { |str| (str.include?("_id") && str != "agreement_id") }
    render json: { searchable_columns: searchable_columns }, status: :ok
  end

  private

  def account_types
    [ "admin", "caller", "executive" ]
  end
end