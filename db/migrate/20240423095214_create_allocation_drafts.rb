class CreateAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    create_table :allocation_drafts do |t|
      t.string :segment
      t.string :pool
      t.string :branch
      t.string :agreement_id
      t.string :customer_name
      t.string :pro
      t.string :bkt
      t.string :fos_name
      t.string :fos_mobile_no
      t.string :caller_name
      t.string :caller_mo_number
      t.string :f_code
      t.date :ptp_date
      t.string :feedback
      t.string :res
      t.integer :emi_coll
      t.integer :cbc_coll
      t.integer :total_coll
      t.string :fos_id
      t.string :mobile
      t.string :address
      t.string :zipcode
      t.string :phone1
      t.string :phone2
      t.integer :loan_amt
      t.string :pos
      t.float :emi_amt
      t.float :emi_od_amt
      t.string :bcc_pending
      t.string :penal_pending
      t.integer :cycle
      t.integer :tenure
      t.date :disb_date
      t.date :emi_start_date
      t.date :emi_end_date
      t.string :manufacturer_desc
      t.string :asset_cat
      t.string :supplier
      t.string :system_bounce_reason
      t.string :reference1_name
      t.string :reference2_name
      t.string :so_name
      t.string :ro_name
      t.string :all_dt

      t.timestamps
    end
  end
end
