class CreateFeedbackCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :feedback_codes do |t|
      t.string :code
      t.boolean :use_sub_code
      t.string :category
      t.text :description

      t.json :fields

      t.timestamps
    end
    add_index :feedback_codes, :code, unique: true
  end
end
