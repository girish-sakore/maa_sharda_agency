class AddAllocationDraftIdToFeedback < ActiveRecord::Migration[7.1]
  def change
    add_reference :feedbacks, :allocation_draft, null: false, foreign_key: true
  end
end
