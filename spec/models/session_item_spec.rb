require 'rails_helper'

RSpec.describe SessionItem, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :abstract }
  it { is_expected.to validate_presence_of :acceptance }
  it { is_expected.to define_enum_for :acceptance }
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :session }

  describe '.search' do
    subject(:title) { 'Projeto de reformas da rodovia BR-156' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        session_item = create :session_item, title: title

        expect(SessionItem.search(title[0..(title.size / 2).to_i])).to eq [session_item]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        session_item = create :session_item, title: title

        expect(SessionItem.search(title)).to eq [session_item]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :session_item, title: title

        expect(SessionItem.search('234f9vc8nu28933918')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        session_item = create :session_item, title: title

        expect(SessionItem.search('')).to eq [session_item]
      end
    end
  end

  describe '.by_acceptance' do
    let!(:not_voted) { create :session_item, acceptance: :not_voted }
    let!(:approved) { create :session_item, acceptance: :approved }
    let!(:rejected) { create :session_item, acceptance: :rejected }

    context "quando for passado a aceitação 'not_voted'" do
      it 'deve retornar somente itens da ordem do dia não votados' do
        expect(SessionItem.by_acceptance('not_voted')).to eq [not_voted]
        expect(SessionItem.by_acceptance(:not_voted)).to eq [not_voted]
      end
    end

    context "quando for passado a aceitação 'approved'" do
      it 'deve retornar somente itens da ordem do dia aprovados' do
        expect(SessionItem.by_acceptance('approved')).to eq [approved]
        expect(SessionItem.by_acceptance(:approved)).to eq [approved]
      end
    end

    context "quando for passado a aceitação 'rejected'" do
      it 'deve retornar somente itens da ordem do dia rejeitados' do
        expect(SessionItem.by_acceptance('rejected')).to eq [rejected]
        expect(SessionItem.by_acceptance(:rejected)).to eq [rejected]
      end
    end

    context 'quando nada for passado' do
      it 'deve retornar todos os itens da ordem do dia' do
        expect(SessionItem.by_acceptance(nil)).to include(not_voted, approved, rejected)
        expect(SessionItem.by_acceptance('')).to include(not_voted, approved, rejected)
      end
    end
  end
end
