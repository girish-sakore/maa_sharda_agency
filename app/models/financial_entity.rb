class FinancialEntity < ApplicationRecord
  # Associations
  has_many :allocation_drafts

  # Validations
  validates :name, :code, presence: true, uniqueness: true
end
