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

  private

  def attendance_params
    params.require(:attendance).permit(:user_id, :date, :check_in_time, :check_out_time, :status, :notes)
  end

end
