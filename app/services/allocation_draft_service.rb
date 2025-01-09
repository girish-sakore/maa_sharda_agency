class AllocationDraftService
  require 'roo'

  def initialize(user)
    @user = user
  end

  def get_allocations(params) # this approach needs to analyzed in performance testing
    allocations = case @user.type
                  when 'UserBlock::Admin'
                    AllocationDraft.all
                  when 'UserBlock::Executive'
                    AllocationDraft.where(executive_id: @user.id)
                  when 'UserBlock::Caller'
                    AllocationDraft.where(caller_id: @user.id)
                  else
                    AllocationDraft.none
                  end
  
    if params[:q].present?
      search = allocations.ransack(params[:q])
      allocations = search.result
    end
  
    allocations
  end
  

  def export_allocations_to_xlsx(allocations)
    # allocations = get_allocations(month)
    # return false if allocations.empty?

    # Axlsx::Package.new do |p|
    #   p.workbook.add_worksheet(name: "Allocations") do |sheet|
    #     sheet.add_row ['ID', 'Executive ID', 'Caller ID', 'Other Fields...']
    #     allocations.find_each do |allocation|
    #       sheet.add_row [allocation.id, allocation.executive_id, allocation.caller_id, '...']
    #     end
    #   end
    #   p.to_stream.read
    # end
  end

  private

  # kept for future use
  # def set_ransack_auth_object 
  #   @user.is_admin? ? :admin : nil
  # end

end
