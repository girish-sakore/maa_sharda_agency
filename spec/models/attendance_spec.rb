require 'rails_helper'

RSpec.describe Attendance, type: :model do
  let(:caller_user) { FactoryBot.create(:caller) }

  it "is valid with valid attributes" do
    attendance = Attendance.new(user: caller_user, date: Date.today, status: "present")
    expect(attendance).to be_valid
  end

  it "is invalid without a date" do
    attendance = Attendance.new(user: caller_user, status: "present")
    expect(attendance).to_not be_valid
  end

  it "is invalid with duplicate date for same user" do
    Attendance.create!(user: caller_user, date: Date.today, status: "present")
    duplicate = Attendance.new(user: caller_user, date: Date.today, status: "present")
    expect(duplicate).to_not be_valid
  end

  it "is invalid with an invalid status" do
    attendance = Attendance.new(user: caller_user, date: Date.today, status: "vacation")
    expect(attendance).to_not be_valid
  end

  describe "scopes" do
    it "returns attendance for a specific user" do
      a1 = Attendance.create!(user: caller_user, date: Date.today, status: "present")
      expect(Attendance.for_user(caller_user.id)).to include(a1)
    end

    it "detects missing check-out" do
      Attendance.create!(user: caller_user, date: Date.today, status: "present", check_in_time: Time.zone.now)
      expect(Attendance.missing_checkout.count).to eq(1)
    end
  end
end
