require 'rails_helper'

RSpec.describe Permission, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :subject }
  it { is_expected.to belong_to :role }
end
