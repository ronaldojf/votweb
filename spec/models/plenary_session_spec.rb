require 'rails_helper'

RSpec.describe PlenarySession, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_presence_of :start_at }
  it { is_expected.to validate_presence_of :end_at }
  it { is_expected.to define_enum_for :kind }
  it { is_expected.to have_many :polls }
  it { is_expected.to have_many :members }
  it { is_expected.to have_many :items }
  it { is_expected.to accept_nested_attributes_for :members }

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

  describe '.not_test' do
    it 'deve retornar todas as sessão que não forem de teste' do
      plenary_session1 = create :plenary_session, is_test: true
      plenary_session2 = create :plenary_session, is_test: false

      expect(PlenarySession.not_test).to eq [plenary_session2]
    end
  end

  describe '.by_kind' do
    let!(:ordinary) { create :plenary_session, kind: :ordinary }
    let!(:extraordinary) { create :plenary_session, kind: :extraordinary }
    let!(:solemn) { create :plenary_session, kind: :solemn }
    let!(:special) { create :plenary_session, kind: :special }

    context "quando for passado o tipo 'ordinary'" do
      it 'deve retornar somente sessões ordinárias' do
        expect(PlenarySession.by_kind('ordinary')).to eq [ordinary]
        expect(PlenarySession.by_kind(:ordinary)).to eq [ordinary]
      end
    end

    context "quando for passado o tipo 'extraordinary'" do
      it 'deve retornar somente sessões extraordinárias' do
        expect(PlenarySession.by_kind('extraordinary')).to eq [extraordinary]
        expect(PlenarySession.by_kind(:extraordinary)).to eq [extraordinary]
      end
    end

    context "quando for passado o tipo 'solemn'" do
      it 'deve retornar somente sessões solenes' do
        expect(PlenarySession.by_kind('solemn')).to eq [solemn]
        expect(PlenarySession.by_kind(:solemn)).to eq [solemn]
      end
    end

    context "quando for passado o tipo 'special'" do
      it 'deve retornar somente sessões especiais' do
        expect(PlenarySession.by_kind('special')).to eq [special]
        expect(PlenarySession.by_kind(:special)).to eq [special]
      end
    end

    context 'quando nada for passado' do
      it 'deve retornar todos os tipos de sessões' do
        expect(PlenarySession.by_kind(nil)).to include(ordinary, extraordinary, solemn, special)
        expect(PlenarySession.by_kind('')).to include(ordinary, extraordinary, solemn, special)
      end
    end
  end

  describe '.by_test' do
    context "quando for passado 'true'" do
      it 'deve retornar todos os vereadores titulares' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test('true')).to eq [plenary_session1]
        expect(PlenarySession.by_test(true)).to eq [plenary_session1]
      end
    end

    context "quando for passado algo além de 'true'" do
      it 'deve retornar todos os vereadores suplentes' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test('false')).to eq [plenary_session2]
        expect(PlenarySession.by_test(false)).to eq [plenary_session2]
        expect(PlenarySession.by_test('other')).to eq [plenary_session2]
      end
    end

    context "quando nada for passado" do
      it 'deve retornar todos os registros' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test(nil)).to include(plenary_session1, plenary_session2)
      end
    end
  end
end
