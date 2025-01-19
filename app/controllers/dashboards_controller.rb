class DashboardsController < ApplicationController
  before_action :authorize_request

  def get_allocations
    allocation_draft_obj = AllocationDraftService.new(@current_user)
  
    # Fetch paginated data for non-export requests
    allocations = allocation_draft_obj.get_allocations(params)
    paginated_data = allocations.page(params[:page]).per(params[:per_page] || 10)
  
    if params[:export].present? && params[:export].to_s.downcase == 'true'
      if allocations.empty?
        render json: { message: 'No allocations to export', data: [] }, status: :ok
      else
        file_path = ExportAllocationService.call(allocations)
        send_file(file_path, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', filename: "allocations_#{Date.today.to_s}_#{Time.now.to_i}.xlsx")
      end
    else
      message = paginated_data.empty? ? 'No allocations found' : 'Data fetched successfully'
      render json: { 
        data: paginated_data, 
        metadata: {
          total: paginated_data.total_count,
          current_page: paginated_data.current_page,
          next_page: paginated_data.next_page,
          prev_page: paginated_data.prev_page,
          total_pages: paginated_data.total_pages
        },
        message: message 
      }, status: :ok
    end
  end  
  
end