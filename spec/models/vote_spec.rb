require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :poll }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to define_enum_for :kind }
  it { is_expected.to belong_to :poll }
  it { is_expected.to belong_to :councillor }
end
