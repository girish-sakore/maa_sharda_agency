# app/services/allocation_draft_query_service.rb
class AllocationDraftQueryService
  def initialize(params)
    @params = params
    @query = AllocationDraft.all
  end

  def call
    filter
    sort
    # Return the query object without pagination
    { data: @query }
  end

  private

  def filter
    filter_params = [
      :segment, :pool, :branch, :agreement_id, :customer_name, :pro, :bkt,
      :fos_name, :fos_mobile_no, :caller_name, :caller_mo_number, :f_code,
      :ptp_date, :feedback, :res, :emi_coll, :cbc_coll, :total_coll, :fos_id,
      :mobile, :address, :zipcode, :phone1, :phone2, :loan_amt, :pos, :emi_amt,
      :emi_od_amt, :bcc_pending, :penal_pending, :cycle, :tenure, :disb_date,
      :emi_start_date, :emi_end_date, :manufacturer_desc, :asset_cat, :supplier,
      :system_bounce_reason, :reference1_name, :reference2_name, :so_name, :ro_name,
      :all_dt
    ]

    filter_params.each do |param|
      if @params[param].present?
        if param.to_s.ends_with?('_date') && @params[param].present?
          @query = @query.where(param => @params[param])
        elsif param.to_s.ends_with?('_amt') || param.to_s.ends_with?('_coll') || param.to_s.ends_with?('_amt')
          @query = @query.where(param => @params[param].to_f)
        elsif param.to_s.ends_with?('_coll') || param.to_s.ends_with?('_amt') || param.to_s.ends_with?('_date')
          @query = @query.where(param => @params[param].to_i)
        else
          @query = @query.where(param => @params[param])
        end
      end
    end
  end

  def sort
    sort_column = @params[:sort_column] || 'created_at'
    sort_direction = @params[:sort_direction] || 'asc'
    valid_sort_columns = AllocationDraft.column_names
    sort_column = valid_sort_columns.include?(sort_column) ? sort_column : 'created_at'
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : 'asc'
    @query = @query.order("#{sort_column} #{sort_direction}")
  end
end
