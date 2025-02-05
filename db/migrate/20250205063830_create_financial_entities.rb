class CreateFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_entities do |t|
      t.string :name
      t.string :code
      t.string :contact_number
      t.string :email

      t.timestamps
    end
  end
end
