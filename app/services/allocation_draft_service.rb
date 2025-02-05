class AllocationDraftService
  require 'roo'

  def initialize(user)
    @user = user
  end

  def get_allocations(params) # this approach needs to analyzed in performance testing
    allocations = case @user.type
                  when 'UserBlock::Admin'
                    AllocationDraft.current_month.all
                  when 'UserBlock::Executive'
                    AllocationDraft.current_month.where(executive_id: @user.id)
                  when 'UserBlock::Caller'
                    AllocationDraft.current_month.where(caller_id: @user.id)
                  else
                    AllocationDraft.none
                  end
  
    if params[:q].present?
      search = allocations.ransack(params[:q])
      allocations = search.result
    end
  
    allocations
  end

  private

  # kept for future use
  # def set_ransack_auth_object 
  #   @user.is_admin? ? :admin : nil
  # end

end
