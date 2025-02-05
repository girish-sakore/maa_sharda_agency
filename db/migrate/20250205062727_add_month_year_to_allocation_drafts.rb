class AddMonthYearToAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    add_column :allocation_drafts, :month, :integer
    add_column :allocation_drafts, :year, :integer
    add_index :allocation_drafts, [:month, :year], name: 'index_allocation_drafts_on_month_year'
  end
end
