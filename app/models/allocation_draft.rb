class AllocationDraft < ApplicationRecord
  # Associations
  belongs_to :caller, class_name: 'UserBlock::Caller', optional: true
  belongs_to :executive, class_name: 'UserBlock::Executive', optional: true
  belongs_to :financial_entity
  # Validations
  validates :customer_name, :bkt, :zipcode, :agreement_id, presence: true
  validates :caller_id, presence: true, if: :assigned_to_caller?
  validates :executive_id, presence: true, if: :assigned_to_executive?
  validates :financial_entity_id, presence: true

  validates :month, presence: true, 
                  numericality: { 
                    only_integer: true, 
                    greater_than_or_equal_to: 1, 
                    less_than_or_equal_to: 12 
                  }
  validates :year, presence: true, 
                 numericality: { 
                   only_integer: true, 
                   greater_than_or_equal_to: 2000 
                 }
  # Callbacks
  before_commit :update_fos_details, if: :caller_or_executive_changed?

  # Scopes
  scope :current_month, -> { 
    where(month: Date.current.month, year: Date.current.year) 
  }
  scope :by_month_year, ->(m, y) { where(month: m, year: y) }

  scope :by_entity_and_month_year, ->(entity_id, m, y) {
    where(financial_entity_id: entity_id, month: m, year: y)
  }

  # Methods
  def assigned_to_caller?
    caller_id.present?
  end

  def assigned_to_executive?
    executive_id.present?
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ["address", "agreement_id", "all_dt", "asset_cat", "bcc_pending", "bkt", "branch",
    "caller_id", "caller_mo_number", "caller_name", "cbc_coll", "created_at", "customer_name",
    "cycle", "disb_date", "emi_amt", "emi_coll", "emi_end_date", "emi_od_amt", "emi_start_date", "executive_id",
    "f_code", "feedback", "fos_id", "fos_mobile_no", "fos_name", "id", "id_value", "loan_amt", "manufacturer_desc",
    "mobile", "penal_pending", "phone1", "phone2", "pool", "pos", "pro", "ptp_date", "reference1_name",
    "reference2_name", "res", "ro_name", "segment", "so_name", "supplier", "system_bounce_reason", "tenure",
    "total_coll", "updated_at", "zipcode"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["caller", "executive"]
  end

  def caller_or_executive_changed?
    saved_change_to_caller_id? || saved_change_to_executive_id?
  end

  def update_fos_details
    update_caller_fos_details if self.assigned_to_caller?
    update_executive_fos_details if self.assigned_to_executive?
  end

  def update_caller_fos_details
    self.caller_name = self.caller.name
  end

  def update_executive_fos_details
    self.fos_name = self.executive.name
    # self.fos_mobile_no = ############### TODO in PROD
  end

  def self.batch_update_fos_details(record_ids)
    records = where(id: record_ids)

    # Fetching all caller & executive details in a single query
    caller_data = UserBlock::Caller.where(id: records.pluck(:caller_id)).pluck(:id, :name).to_h
    executive_data = UserBlock::Executive.where(id: records.pluck(:executive_id)).pluck(:id, :name).to_h

    # Updating records in batch
    records.find_each do |record|
      updates = {}
      updates[:caller_name] = caller_data[record.caller_id] if record.assigned_to_caller?
      updates[:fos_name] = executive_data[record.executive_id] if record.assigned_to_executive?
      record.update_columns(updates) if updates.present?
    end
  end

end