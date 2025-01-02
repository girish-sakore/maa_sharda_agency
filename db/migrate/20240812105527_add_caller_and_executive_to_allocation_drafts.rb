class AddCallerAndExecutiveToAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    add_reference :allocation_drafts, :caller, null: true, foreign_key: { to_table: :users }
    add_reference :allocation_drafts, :executive, null: true, foreign_key: { to_table: :users }
  end
end
