require 'rails_helper'

RSpec.describe Countdown, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to belong_to :plenary_session }

  describe '#to_builder' do
    it 'deve retornar uma instância do JBuilder com os principais atributos do objeto' do
      Timecop.freeze do
        countdown = build :countdown, description: nil, duration: 20, created_at: DateTime.current

        expect(countdown.to_builder.attributes!).to eq({
          'id' => nil,
          'plenary_session_id' => countdown.plenary_session.id,
          'description' => nil,
          'countdown' => 20,
          'duration' => 20,
          'created_at' => DateTime.current
        })
      end
    end
  end
end
