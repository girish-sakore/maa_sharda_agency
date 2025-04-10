class AddAutoMarkedToAttendances < ActiveRecord::Migration[7.1]
  def change
    add_column :attendances, :auto_marked, :boolean
  end
end
