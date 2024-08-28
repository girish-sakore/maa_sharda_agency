class AllocationDraftsController < ApplicationController
  before_action :authorize_request
  before_action :not_admin?

  def import_allocation
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
    search = AllocationDraft.ransack(params[:q])
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

  def assign_caller
    caller_id = params[:caller_id]
    allocation_draft_ids = params[:allocation_draft_ids]

    if caller_id.present? && allocation_draft_ids.present?
      caller = UserBlock::Caller.find_by(id: caller_id)
      if caller
        allocation_drafts = AllocationDraft.where(id: allocation_draft_ids)
        missing_ids = allocation_draft_ids - allocation_drafts.pluck(:id)

        if allocation_drafts.any?
          # Exclude already assigned drafts
          drafts_to_update = allocation_drafts

          drafts_to_update.update_all(caller_id: caller_id)

          response_data = {
            message: "Caller assigned with some conditions",
            updated: allocation_drafts,
            not_found: missing_ids
          }

          render json: response_data, status: :ok
        else
          render json: { error: "No valid AllocationDrafts found with the given IDs" }, status: :not_found
        end
      else
        render json: { error: "Caller not found" }, status: :not_found
      end
    else
      render json: { error: "Caller ID and Allocation Draft IDs are required" }, status: :bad_request
    end
  end

  def assign_executive
    executive_id = params[:executive_id]
    allocation_draft_ids = params[:allocation_draft_ids]
  
    if executive_id.present? && allocation_draft_ids.present?
      executive = UserBlock::Executive.find_by(id: executive_id)
      if executive
        allocation_drafts = AllocationDraft.where(id: allocation_draft_ids)
        missing_ids = allocation_draft_ids - allocation_drafts.pluck(:id)
  
        if allocation_drafts.any?
          # Exclude already assigned drafts
          drafts_to_update = allocation_drafts
  
          drafts_to_update.update_all(executive_id: executive_id)
  
          response_data = {
            message: "Executive assigned with some conditions",
            updated: allocation_drafts,
            not_found: missing_ids
          }
  
          render json: response_data, status: :ok
        else
          render json: { error: "No valid AllocationDrafts found with the given IDs" }, status: :not_found
        end
      else
        render json: { error: "Executive not found" }, status: :not_found
      end
    else
      render json: { error: "Executive ID and Allocation Draft IDs are required" }, status: :bad_request
    end
  end

end