require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to validate_presence_of :councillor }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to define_enum_for :kind }
  it { is_expected.to belong_to :plenary_session }
  it { is_expected.to belong_to :councillor }

  context 'quando forem criados 2 tipos iguais de inscrição para a mesma sessão e vereador' do
    it 'não deve ser válido' do
      plenary_session = create :plenary_session
      councillor = create :councillor

      subscription1 = create :subscription, plenary_session: plenary_session, councillor: councillor, kind: 'expedient'
      subscription2 = build :subscription, plenary_session: plenary_session, councillor: councillor, kind: 'expedient'

      expect(subscription1).to be_valid
      expect(subscription2).to_not be_valid
    end
  end

  context 'quando não for criados 2 tipos iguais de inscrição para a mesma sessão e vereador' do
    it 'deve ser válido' do
      plenary_session1 = create :plenary_session
      plenary_session2 = create :plenary_session
      councillor1 = create :councillor
      councillor2 = create :councillor

      subscription1 = create :subscription, plenary_session: plenary_session1, councillor: councillor1, kind: 'expedient'
      subscription2 = create :subscription, plenary_session: plenary_session1, councillor: councillor2, kind: 'expedient'
      subscription3 = create :subscription, plenary_session: plenary_session2, councillor: councillor1, kind: 'expedient'
      subscription4 = create :subscription, plenary_session: plenary_session2, councillor: councillor2, kind: 'expedient'
      subscription5 = create :subscription, plenary_session: plenary_session2, councillor: councillor2, kind: 'notice'

      expect(subscription1).to be_valid
      expect(subscription2).to be_valid
      expect(subscription3).to be_valid
      expect(subscription4).to be_valid
      expect(subscription5).to be_valid
    end
  end

  describe '#destroy' do
    context 'quando o atributo is_done estiver marcado' do
      it 'não permite que um registro seja destruído' do
        subscription = create :subscription, is_done: true

        expect { subscription.destroy }.to change(Subscription, :count).by(0)
      end
    end

    context 'quando o atributo is_done não estiver marcado' do
      it 'permite que um registro seja destruído' do
        subscription = create :subscription, is_done: false

        expect { subscription.destroy }.to change(Subscription, :count).from(1).to(0)
      end
    end
  end

  describe '#to_builder' do
    it 'deve retornar uma instância do JBuilder com os principais atributos do objeto' do
      Timecop.freeze do
        subscription = build :subscription, kind: :explanation, created_at: DateTime.current

        expect(subscription.to_builder.attributes!).to eq({
          'id' => nil,
          'plenary_session_id' => subscription.plenary_session_id,
          'councillor_id' => subscription.councillor_id,
          'kind' => 'explanation',
          'is_done' => false,
          'created_at' => DateTime.current,
          '_destroyed' => false
        })
      end
    end
  end
end
