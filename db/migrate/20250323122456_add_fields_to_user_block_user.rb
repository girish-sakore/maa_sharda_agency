class AddFieldsToUserBlockUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :mobile_number, :string
    add_column :users, :alt_mobile_number, :string
    add_column :users, :verified, :boolean, :default=> false
    add_column :users, :status, :integer, :default=> 0
  end
end
