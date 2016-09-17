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

  describe '#stop_countdown' do
    context 'se a data de criação somada à duração ainda for futura' do
      it 'deve alterar a duração para a quantidade de tempo em segundos que se passou desde que o registro foi criado, até que esse método foi executado' do
        Timecop.freeze do
          poll = create :poll, duration: 20

          Timecop.travel 12.seconds.from_now do
            poll.stop_countdown
          end

          expect(poll.reload.duration).to eq 12
        end
      end
    end

    context 'se a data de criação somada à duração já tiver passado' do
      it 'não deve alterar a duração' do
        Timecop.freeze do
          poll = create :poll, duration: 20

          Timecop.travel 22.seconds.from_now do
            poll.stop_countdown
          end

          expect(poll.reload.duration).to eq 20
        end
      end
    end
  end
end
