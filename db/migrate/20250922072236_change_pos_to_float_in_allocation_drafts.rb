class ChangePosToFloatInAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    change_column :allocation_drafts, :pos, :float, using: 'pos::float'
  end
end
