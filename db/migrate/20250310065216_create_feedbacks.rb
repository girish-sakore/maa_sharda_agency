class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.references :feedback_code, null: false, foreign_key: true
      t.decimal :amount
      t.text :remarks
      t.date :next_payment_date
      t.date :ptp_date
      t.decimal :settlement_amount
      t.date :settlement_date
      t.string :new_address

      t.timestamps
    end
  end
end
