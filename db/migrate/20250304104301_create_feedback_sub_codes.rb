class CreateFeedbackSubCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :feedback_sub_codes do |t|
      t.references :feedback_code, null: false, foreign_key: true
      t.string :sub_code, null: false
      t.text :description
      t.text :fields, array: true, default: []

      t.timestamps
    end
  end
end
