require 'rails_helper'

RSpec.describe MarkAbsentJob, type: :job do
  let!(:caller) { FactoryBot.create(:caller) }
  let!(:executive) { FactoryBot.create(:executive) }

  it "creates absent records for users with no attendance today" do
    expect {
      described_class.perform_now(Date.today)
    }.to change { Attendance.where(status: 'absent').count }.by(2)
  end

  it "does not override existing attendance" do
    FactoryBot.create(:attendance, user: caller, date: Date.today, status: 'present')
    described_class.perform_now(Date.today)
    expect(caller.attendances.where(date: Date.today).pluck(:status)).to eq(['present'])
  end
end