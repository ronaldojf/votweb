require 'rails_helper'

RSpec.describe Hold, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :reference_id }
  it { is_expected.to validate_uniqueness_of(:reference_id).case_insensitive }

  describe '.search' do
    subject(:reference_id) { 'CAD-12' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        hold = create :hold, reference_id: reference_id

        expect(Hold.search(reference_id[0..(reference_id.size / 2).to_i])).to eq [hold]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        hold = create :hold, reference_id: reference_id

        expect(Hold.search(reference_id)).to eq [hold]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :hold, reference_id: reference_id

        expect(Hold.search('234f9vc8nu28933918')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        hold = create :hold, reference_id: reference_id

        expect(Hold.search('')).to eq [hold]
      end
    end
  end
end
