class FeedbackCode < ApplicationRecord
  has_many :sub_codes, class_name: 'FeedbackSubCode', foreign_key: 'feedback_code_id', dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: %w(CALLING VISIT COMMON), message: "%{value} is not a valid category" }

  enum category: { CALLING: 'CALLING', VISIT: 'VISIT', COMMON: 'COMMON' }

  accepts_nested_attributes_for :sub_codes, allow_destroy: true
end
