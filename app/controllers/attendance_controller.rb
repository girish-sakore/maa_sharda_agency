class AttendanceController < ApplicationController
  before_action :ensure_role_is_allowed!

  def today
    # user = @current_user || User.find(params[:user_id])
    today_attendance = Attendance.find_by(user: @current_user, date: Date.current)
  
    if today_attendance
      render json: today_attendance
    else
      render json: { status: 'not_found' }
    end
  end

  def check_in
    today = Date.today

    attendance = Attendance.find_or_initialize_by(user_id: @current_user.id, date: today)
    if attendance.persisted?
      render json: { error: 'Already checked in today' }, status: :unprocessable_entity
    else
      attendance.check_in_time = Time.current
      attendance.status = infer_status(attendance.check_in_time)
      if attendance.save
        render json: attendance, status: :created
      else
        render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def check_out
    attendance = Attendance.find_by(user_id: @current_user.id, date: Date.today)

    unless attendance
      return render json: { error: 'No check-in found for today' }, status: :not_found
    end

    if attendance.check_out_time.present?
      render json: { error: 'Already checked out' }, status: :unprocessable_entity
    else
      attendance.update(check_out_time: Time.current)
      render json: attendance
    end
  end

  private

  def ensure_role_is_allowed!
    unless @current_user.can_mark_attendance?
      render json: { error: 'Not authorized to mark attendance' }, status: :forbidden
    end
  end

  def infer_status(check_in_time)
    late_threshold = Time.zone.parse("09:30")
    check_in_time > late_threshold ? "late" : "present"
  end
end
