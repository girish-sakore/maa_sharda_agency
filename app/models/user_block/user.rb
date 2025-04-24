# frozen_string_literal: true
module UserBlock
  class User < ApplicationRecord
    self.table_name = 'users'
    has_secure_password

    enum status: { inactive: 0, active: 1, pending: 2, suspended: 3 }

    # Associations
    has_many :attendances, dependent: :destroy

    # Callbacks
    before_save { email.downcase}

    # Validations
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :mobile_number, :type, presence: true
    validates :password, length: { minimum: 8 }, if: -> { password.present? }
    validates :name, presence: true, length: { maximum: 50 }
    validates :mobile_number, length: { is: 10, message: 'must be 10 digits' }, numericality: { only_integer: true, message: 'only numbers allowed' }, allow_blank: false
    validates :alt_mobile_number, length: { is: 10, message: 'must be 10 digits' }, numericality: { only_integer: true, message: 'only numbers allowed' }, allow_blank: true

    validate :valid_type
    validate :unique_mobile_numbers, if: -> { mobile_number.present? }

    # Public methods
    def is_admin?
      is_a?(UserBlock::Admin)
    end

    def is_caller?
      is_a?(UserBlock::Caller)
    end

    def is_executive?
      is_a?(UserBlock::Executive)
    end

    def can_mark_attendance?
      is_caller? or is_executive?
    end

    def role_name
      case self.type
      when 'UserBlock::Admin'
        'Admin'
      when 'UserBlock::Caller'
        'Caller'
      when 'UserBlock::Executive'
        'Executive'
      else
        'Unknown'
      end
    end

    private

    def valid_type
      allowed_types = ['UserBlock::Admin', 'UserBlock::Caller', 'UserBlock::Executive']
      errors.add(:type, "Invalid type") unless allowed_types.include?(type)
    end

    def unique_mobile_numbers
      # Check if mobile_number is unique across all users' mobile_number and alt_mobile_number
      if User.where.not(id: id).where(mobile_number: mobile_number).or(
           User.where.not(id: id).where(alt_mobile_number: mobile_number)
         ).exists?
        errors.add(:mobile_number, 'has already been taken')
      end
  
      # Check if alt_mobile_number is unique across all users' mobile_number and alt_mobile_number
      if alt_mobile_number.present? && User.where.not(id: id).where(mobile_number: alt_mobile_number).or(
           User.where.not(id: id).where(alt_mobile_number: alt_mobile_number)
         ).exists?
        errors.add(:alt_mobile_number, 'has already been taken')
      end
  
      # Ensure mobile_number and alt_mobile_number are not the same for the same user
      if mobile_number.present? && alt_mobile_number.present? && mobile_number == alt_mobile_number
        errors.add(:alt_mobile_number, 'cannot be the same as mobile number')
      end
    end
  end
end
