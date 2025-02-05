class AllocationDraftsController < ApplicationController
  before_action :authorize_request
  before_action :not_admin?

  def import_allocation
    file_path = params[:file]
    entity = params[:financial_entity_id] || FinancialEntity.first # Until finalized
    errors, success = ImportAllocationService.new(file_path, entity).import
    if errors.empty?
      render json: { message: 'Data imported successfully!' }, status: :ok
    else
      render json: { errors: errors, success: success }, status: :ok
    end
  rescue => e
    file_name, line_number = caller.first.split(':')[0..1]
    render json: { error: 'Import failed', exception: e.message, trace: "#{file_name}:#{line_number}" }, status: :unprocessable_entity
  end

  def index
    allocations = if params[:month].present? && params[:year].present?
                    AllocationDraft.by_month_year(params[:month], params[:year])
                  else
                    AllocationDraft.current_month
                  end
    search = allocations.ransack(params[:q])
    data = search.result

    page = params[:page] || 1
    per_page = params[:per_page] || 10

    paginated_data = data.page(page).per(per_page)

    metadata = {
      total: paginated_data.total_count,
      current_page: paginated_data.current_page,
      next_page: paginated_data.next_page,
      prev_page: paginated_data.prev_page,
      total_pages: paginated_data.total_pages
    }

    render json: { metadata: metadata, data: paginated_data }
  end

  def update
    allocation = AllocationDraft.find(params[:id])
    if allocation
      if allocation.update(allocation_drafts_params)
        render json: { allocation: allocation, message: 'data updated'}, status: :ok
      else
        render json: { message: 'error saving', error: allocation.errors }, status: :unprocessable_entity
      end
    end
  end

  def assign_caller
    caller_id = params[:caller_id]
    allocation_draft_ids = params[:allocation_draft_ids]&.map(&:to_i)
  
    return render json: { error: "Caller ID and Allocation Draft IDs are required" }, status: :bad_request unless caller_id.present? && allocation_draft_ids.present?
  
    caller = UserBlock::Caller.find_by(id: caller_id)
    return render json: { error: "Caller not found" }, status: :not_found unless caller
  
    allocation_drafts = AllocationDraft.where(id: allocation_draft_ids)
    found_ids = allocation_drafts.pluck(:id)
    missing_ids = allocation_draft_ids - found_ids
  
    return render json: { error: "No valid AllocationDrafts found with the given IDs" }, status: :not_found if allocation_drafts.empty?
  
    allocation_drafts.update_all(caller_id: caller_id, caller_name: caller.name)
  
    render json: { message: "Caller assigned successfully", updated_count: found_ids.size, not_found: missing_ids }, status: :ok
  end  

  def assign_executive
    executive_id = params[:executive_id]
    allocation_draft_ids = params[:allocation_draft_ids]&.map(&:to_i)
  
    return render json: { error: "Executive ID and Allocation Draft IDs are required" }, status: :bad_request unless executive_id.present? && allocation_draft_ids.present?
  
    executive = UserBlock::Executive.find_by(id: executive_id)
    return render json: { error: "Executive not found" }, status: :not_found unless executive
  
    allocation_drafts = AllocationDraft.where(id: allocation_draft_ids)
    found_ids = allocation_drafts.pluck(:id)
    missing_ids = allocation_draft_ids - found_ids
  
    return render json: { error: "No valid AllocationDrafts found with the given IDs" }, status: :not_found if allocation_drafts.empty?
  
    allocation_drafts.update_all(executive_id: executive_id, fos_name: executive.name)
  
    render json: { message: "Executive assigned successfully", updated_count: found_ids.size, not_found: missing_ids }, status: :ok
  end  

  private

  def allocation_drafts_params
    params[:data].permit!
  end
end