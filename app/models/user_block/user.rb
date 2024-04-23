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
  end
end
