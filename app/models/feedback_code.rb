class FeedbackCode < ApplicationRecord
  has_many :sub_codes, dependent: :destroy
  validates :code, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: %w(CALLING VISIT BOTH), message: "%{value} is not a valid category" }

  enum category: { CALLING: 'CALLING', VISIT: 'VISIT', BOTH: 'BOTH' }

  accepts_nested_attributes_for :sub_codes, allow_destroy: true
end
