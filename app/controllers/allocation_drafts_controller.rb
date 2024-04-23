class AllocationDraftsController < ApplicationController

  def import
    file_path = params[:file]
    errors, success = ImportAllocationService.new(file_path).import
    if errors.empty?
      render json: { notice: "Data imported successfully!" }, status: :ok
    else
      render json: { errors: errors, success: success }
    end
  end

  def index
    data = AllocationDraft.all
    render json: { data: data }
  end
end