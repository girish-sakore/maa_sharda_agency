class AllocationDraftService
  require 'roo'
  require 'axlsx'

  def initialize(user)
    @user = user
  end

  def get_allocations(month)
    search = AllocationDraft.ransack(params[:q])
    allocations = search.result

    case @user.type
    when 'Userblock::Admin'
      allocations
    when 'Userblock::Executive'
      allocations.where(executive_id: @user.id)
    when 'Userblock::Caller'
      allocations.where(caller_id: @user.id)
    else
      AllocationDraft.none
    end
  end

  def export_allocations_to_xlsx(allocations)
    # allocations = get_allocations(month)
    return false if allocations.empty?

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "Allocations") do |sheet|
        sheet.add_row ['ID', 'Executive ID', 'Caller ID', 'Other Fields...']
        allocations.find_each do |allocation|
          sheet.add_row [allocation.id, allocation.executive_id, allocation.caller_id, '...']
        end
      end
      p.to_stream.read
    end
  end
end
