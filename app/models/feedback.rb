class Feedback < ApplicationRecord
  belongs_to :feedback_code
  belongs_to :allocation_draft, class_name: "AllocationDraft"

  # required fields validations
  validate :required_field_validation

  # specific fields validations
  validate :ptp_date_in_future_within_month, if: :ptp_date?
  validate :next_payment_date_in_future_within_month, if: :next_payment_date?

  # code/case specific validations
  validate :validate_paid, if: :is_paid?
  validate :validate_part_paid, if: :is_ppd?

  private

  def required_field_validation
    return unless feedback_code
    feedback_code.fields.each do |field_name|
      case field_name
      when 'amount'
        if amount.blank?
          errors.add(:amount, :blank)
        elsif !amount.is_a?(Numeric) || amount <= 0
          errors.add(:amount, 'must be a number greater than zero')
        end
      when 'remarks'
        if remarks.blank?
          errors.add(:remarks, :blank)
        end
      when 'next_payment_date'
        if next_payment_date.blank?
          errors.add(:next_payment_date, :blank)
        end
      when 'ptp_date'
        if ptp_date.blank?
          errors.add(:ptp_date, :blank)
        end
      when 'settlement_amount'
        if settlement_amount.blank?
          errors.add(:settlement_amount, :blank)
        elsif !settlement_amount.is_a?(Numeric) || settlement_amount <= 0
          errors.add(:settlement_amount, 'must be a number greater than zero')
        end
      when 'settlement_date'
        if settlement_date.blank?
          errors.add(:settlement_date, :blank)
        end
      when 'new_address'
        if new_address.blank?
          errors.add(:new_address, :blank)
        end
      else
        attribute_value = public_send(field_name.to_sym)
        if attribute_value.blank?
          errors.add(field_name.to_sym, :blank)
        end
      end
    end
  end

  def validate_paid
    min_amount = allocation_draft.emi_amt

    if amount.present? && amount < min_amount
      errors.add(:amount, "cannot be lesser than the (#{min_amount})")
    end
  end

  def validate_part_paid
    min_amount = allocation_draft.emi_amt
    # TODO - resolution
    if amount.present? && amount < min_amount
      errors.add(:amount, "cannot be lesser than the (#{min_amount})")
    end
   
  end

  def ptp_date_in_future_within_month
    validate_date_in_future_within_month(:ptp_date)
  end

  def next_payment_date_in_future_within_month
    validate_date_in_future_within_month(:next_payment_date)
  end

  def validate_date_in_future_within_month(attribute)
    date = self.send(attribute)
    if date <= Date.today
      errors.add(attribute, "cannot be in the past")
    elsif date > 1.month.from_now.to_date
      errors.add(attribute, "must be within this month")
    end
  end

  protected

  def is_paid?
    feedback_code.code == "PAID"
  end

  def is_ppd?
    feedback_code.code == "PPD"
  end
end
