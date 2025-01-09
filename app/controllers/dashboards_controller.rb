class DashboardsController < ApplicationController
  before_action :authorize_request

  def get_allocations
    allocation_draft_obj = AllocationDraftService.new(@current_user)
    data = allocation_draft_obj.get_allocations(params)
    message = data.empty? ? 'No allocations found' : 'Data fetched successfully'
    render json: { data: data, message: message }, status: :ok
  end
end