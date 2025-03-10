class CreateFeedbackCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :feedback_codes do |t|
      t.string :code, null: false
      t.boolean :use_sub_code, default: false
      t.string :category
      t.text :description
      t.text :fields, array: true, default: []

      t.timestamps
    end
    add_index :feedback_codes, :code, unique: true
  end
end
