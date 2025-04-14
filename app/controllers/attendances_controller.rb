class AttendancesController < ApplicationController
  before_action :not_admin?

  def index
    records = Attendance.includes(:user).order(date: :desc).limit(100)
    render json: records, status: :ok
  end

  def show
    attendance = Attendance.find(params[:id])
    render json: attendance
  end

  def create
    attendance = Attendance.new(attendance_params)
    if attendance.save
      render json: attendance, status: :created
    else
      render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    attendance = Attendance.find(params[:id])
    if attendance.update(attendance_params)
      render json: attendance
    else
      render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_attendance
    user = UserBlock::User.find(params[:id])
    attendances = user.attendances.order(date: :desc)
    render json: attendances
  end

  def today_all
    users = UserBlock::User.where(type: ['UserBlock::Caller', 'UserBlock::Executive'])
    attendances = Attendance.where(date: Date.today)
    result = users.map do |user|
      attendance = attendances.find { |a| a.user_id == user.id }
      {
        id: user.id,
        name: user.name,
        role: user.role_name,
        status: attendance&.status || 'absent',
        check_in_time: attendance&.check_in_time,
        check_out_time: attendance&.check_out_time,
      }
    end

    render json: result
  end

  def daily
    date = Date.parse(params[:date]) rescue Date.today
    users = UserBlock::User.where(type: ['UserBlock::Caller', 'UserBlock::Executive'])
    attendances = Attendance.where(date: date)

  
    result = users.map do |user|
      attendance = attendances.find { |a| a.user_id == user.id }
      {
        id: user.id,
        name: user.name,
        role: user.role_name,
        status: attendance&.status || 'absent',
        check_in_time: attendance&.check_in_time,
        check_out_time: attendance&.check_out_time,
      }
    end
  
    render json: result
  end

  def monthly
    month = Date.parse(params[:month] + "-01") rescue Date.today.beginning_of_month
    start_date = month.beginning_of_month
    end_date = month.end_of_month
  
    users = UserBlock::User.where(type: ['UserBlock::Caller', 'UserBlock::Executive'])
    attendances = Attendance.where(date: start_date..end_date)
  
    result = users.map do |user|
      user_att = attendances.select { |a| a.user_id == user.id }

      {
        id: user.id,
        name: user.name,
        role: user.role_name,
        present: user_att.count { |a| a.status == 'present' },
        late: user_att.count { |a| a.status == 'late' },
        absent: user_att.count { |a| a.status == 'absent' },
        on_leave: user_att.count { |a| a.status == 'on_leave' },
        # absent: (end_date - start_date + 1).to_i - user_att.count,
      }
    end
  
    render json: result
  end

  def logged_in_now
    attendances = Attendance
      .where(date: Date.today)
      .where.not(check_in_time: nil)
      .where(check_out_time: nil)
  
    users = UserBlock::User.where(id: attendances.map(&:user_id))
  
    result = users.map do |user|
      att = attendances.find { |a| a.user_id == user.id }
      {
        id: user.id,
        name: user.name,
        role: user.role_name,
        check_in_time: att.check_in_time,
      }
    end
  
    render json: result
  end

  private

  def attendance_params
    params.require(:attendance).permit(:user_id, :date, :check_in_time, :check_out_time, :status, :notes)
  end

end
