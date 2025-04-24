class Attendance < ApplicationRecord
  belongs_to :user, class_name: 'UserBlock::User'

  STATUSES = %w[present late absent on_leave].freeze

  validates :date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :date, message: "already has attendance marked for this date" }

  scope :for_user, ->(user_id) { where(user_id:) }
  scope :on_date, ->(date) { where(date:) }
  scope :present_or_late, -> { where(status: %w[present late]) }
  scope :missing_checkout, -> { where(check_out_time: nil).where.not(check_in_time: nil) }

  # scopes for reports
  scope :for_date, ->(date) { where(date: date) }
  scope :for_month, ->(month_date) {
    where(date: month_date.beginning_of_month..month_date.end_of_month)
  }

  def self.for_today(user)
    find_by(user_id: user.id, date: Date.today)
  end
end
