class DashboardsController < ApplicationController
  def get_allocations
    allocation_draft_obj = AllocationDraftService.new(@current_user)
    data = allocation_draft_obj.get_allocations(month)
  end
end