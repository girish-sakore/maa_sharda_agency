class AddFinancialEntityIdToAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    add_column :allocation_drafts, :financial_entity_id, :integer
    add_index :allocation_drafts, :financial_entity_id
    add_index :allocation_drafts, [:financial_entity_id, :month, :year], name: 'index_entity_month_year'
  end
end
