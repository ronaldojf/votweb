require 'rails_helper'

RSpec.describe Poll, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :process }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to define_enum_for :process }
  it { is_expected.to belong_to :plenary_session }
  it { is_expected.to belong_to :session_item }
  it { is_expected.to have_many :votes }

  it "deve retornar 'duration' como tempo de duração em segundos" do
    poll = build :poll, duration: 5

    expect(poll.duration).to eq 5.seconds
  end
end
