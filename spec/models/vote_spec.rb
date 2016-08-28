require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :session_item }
  it { is_expected.to validate_presence_of :councillor }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to belong_to :session_item }
  it { is_expected.to belong_to :councillor }
  it { is_expected.to belong_to :plenary_session }

  describe '#destroy' do
    it 'não deve possibilitar a exclusão de um voto por padrão' do
      vote = create :vote

      expect(vote.destroy).to be false
      expect(Vote.all).to eq [vote]
    end
  end
end
