# frozen_string_literal: true
module UserBlock
  class User < ApplicationRecord
    self.table_name = 'users'
    has_secure_password

    # Callbacks
    before_save {self.email = email.downcase}

    # Validations
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 8 }
    validate :valid_type
    validates :type, presence: true

    # Public methods
    def is_admin?
      self.is_a?(UserBlock::Admin)
    end

    def is_caller?
      self.is_a?(UserBlock::Caller)
    end

    def is_executive?
      self.is_a?(UserBlock::Executive)
    end

    private

    def valid_type
      allowed_types = ['UserBlock::Admin', 'UserBlock::Caller', 'UserBlock::Executive']
      unless allowed_types.include?(self.type)
        errors.add(:type, "Invalid type")
      end
    end
  end
end
