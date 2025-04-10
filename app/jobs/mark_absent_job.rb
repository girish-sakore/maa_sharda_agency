class MarkAbsentJob < ApplicationJob
  queue_as :default

  def perform(date = Date.today)
    user_classes = [UserBlock::Caller, UserBlock::Executive]
    users_to_check = user_classes.flat_map(&:all)

    users_to_check.each do |user|
      next if user.attendances.exists?(date: date)

      user.attendances.create!(
        date: date,
        status: 'absent',
        auto_marked: true
      )
    end
  end
end