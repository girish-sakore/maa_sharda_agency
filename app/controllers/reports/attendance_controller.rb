class Reports::AttendanceController < ApplicationController
  before_action :not_admin?

  def daily
    date = params[:date]&.to_date || Date.today
    records = Attendance.includes(:user).for_date(date)

    render json: {
      date: date,
      summary: records.group(:status).count,
      details: records.map { |r| { user_id: r.user_id, name: r.user.name, status: r.status } }
    }
  end

  def monthly
    user = UserBlock::User.find(params[:user_id])
    date = params[:date].to_date || Date.today
    records = Attendance.where(user: user).for_month(date)

    render json: {
      user_id: user.id,
      name: user.name,
      month: date.strftime("%Y-%m"),
      summary: records.group(:status).count,
      daily_statuses: records.order(:date).map { |r| { date: r.date, status: r.status } }
    }
  end

end
