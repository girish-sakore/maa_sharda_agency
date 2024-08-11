class AllocationDraftsController < ApplicationController
  before_action :not_admin?

  def import
    file_path = params[:file]
    errors, success = ImportAllocationService.new(file_path).import
    if errors.empty?
      render json: { notice: 'Data imported successfully!' }, status: :ok
    else
      render json: { errors: errors, success: success }
    end
  rescue => e
    file_name, line_number = caller.first.split(':')[0..1]
    render json: { error: 'Import failed', exception: e.message, trace: "#{file_name}:#{line_number}" }, status: :unprocessable_entity
  end

  def index
    query_service = AllocationDraftQueryService.new(params)
    filtered_and_sorted_data = query_service.call

    # Calculate pagination metadata
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    data = filtered_and_sorted_data[:data]
    count = data.total_count
    metadata = {
      total: count,
      current_page: data.current_page,
      next_page: data.next_page,
      prev_page: data.prev_page,
      total_pages: data.total_pages
    }

    # Render JSON response with metadata and data
    render json: { metadata: metadata, data: data }
  end

  def assign_caller

  end
end