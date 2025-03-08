class FeedbackSubCode < ApplicationRecord
  belongs_to :feedback_code

  belongs_to :feedback_code
  validates :sub_code, presence: true
  validates :feedback_code_id, presence: true

  validates :sub_code, uniqueness: { scope: :feedback_code_id, message: "should be unique within a Feedback Code" }
end
