# frozen_string_literal: true
module UserBlock
  class User < ApplicationRecord
    self.table_name = 'users'
    has_secure_password

    # Callbacks
    before_save { email.downcase}

    # Validations
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :type, presence: true
    validates :password, length: { minimum: 8 }, if: -> { password.present? }
    validates :name, presence: true, length: { maximum: 50 }
    validate :valid_type

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

    private

    def valid_type
      allowed_types = ['UserBlock::Admin', 'UserBlock::Caller', 'UserBlock::Executive']
      errors.add(:type, "Invalid type") unless allowed_types.include?(type)
    end
  end
end
