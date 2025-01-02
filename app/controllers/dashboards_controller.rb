class DashboardsController < ApplicationController
  def get_allocations
    as = AllocationDraftService.new(@current_user)
    data = as.get_allocations(month)
  end
end