require 'rails_helper'

RSpec.describe PlenarySession, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :start_at }
  it { is_expected.to validate_presence_of :end_at }

  describe '.search' do
    subject(:title) { 'Sessão 12.542 - 2016' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search(title[0..(title.size / 2).to_i])).to eq [plenary_session]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search(title)).to eq [plenary_session]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :plenary_session, title: title

        expect(PlenarySession.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search('')).to eq [plenary_session]
      end
    end
  end
end
