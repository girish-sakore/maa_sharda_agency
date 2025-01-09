class AllocationDraft < ApplicationRecord
  belongs_to :caller, class_name: 'UserBlock::Caller', optional: true
  belongs_to :executive, class_name: 'UserBlock::Executive', optional: true

  validates :customer_name, :bkt, :zipcode, :agreement_id, presence: true
  validates :caller_id, presence: true, if: :assigned_to_caller?
  validates :executive_id, presence: true, if: :assigned_to_executive?

  def assigned_to_caller?
    caller_id.present?
  end

  def assigned_to_executive?
    executive_id.present?
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ["address", "agreement_id", "all_dt", "asset_cat", "bcc_pending", "bkt", "branch", "caller_id", "caller_mo_number", "caller_name", "cbc_coll", "created_at", "customer_name", "cycle", "disb_date", "emi_amt", "emi_coll", "emi_end_date", "emi_od_amt", "emi_start_date", "executive_id", "f_code", "feedback", "fos_id", "fos_mobile_no", "fos_name", "id", "id_value", "loan_amt", "manufacturer_desc", "mobile", "penal_pending", "phone1", "phone2", "pool", "pos", "pro", "ptp_date", "reference1_name", "reference2_name", "res", "ro_name", "segment", "so_name", "supplier", "system_bounce_reason", "tenure", "total_coll", "updated_at", "zipcode"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["caller", "executive"]
  end
end