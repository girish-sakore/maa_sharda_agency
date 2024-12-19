class AllocationDraft < ApplicationRecord
  belongs_to :caller, class_name: 'UserBlock::Caller', optional: true
  belongs_to :executive, class_name: 'UserBlock::Executive', optional: true

  validates :caller_id, presence: true, if: :assigned_to_caller?
  validates :executive_id, presence: true, if: :assigned_to_executive?

  def assigned_to_caller?
    caller_id.present?
  end

  def assigned_to_executive?
    executive_id.present?
  end
end