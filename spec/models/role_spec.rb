require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_uniqueness_of(:description).case_insensitive }
  it { is_expected.to have_many :permissions }
  it { is_expected.to have_and_belong_to_many :administrators }
  it { is_expected.to accept_nested_attributes_for :permissions }

  describe '.search' do
    subject(:description) { 'Administrator' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que possui o valor em parte da descrição' do
        role = create :role, description: description

        expect(Role.search(description[0..(description.size / 2).to_i])).to eq [role]
      end
    end

    context 'quando todo o valor do atributo é passado' do
      it 'deve retornar o registro com a mesma descrição' do
        role = create :role, description: description

        expect(Role.search(description)).to eq [role]
      end
    end

    context 'quando algo que não será encontrado é passado' do
      it 'não retorna nada' do
        create :role, description: description

        expect(Role.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando não é passado nada' do
      it 'deve retornar todos os registros' do
        role = create :role, description: description

        expect(Role.search('')).to eq [role]
      end
    end
  end

  describe '.full_control' do
    it 'deve retornar todas as funções com controle total' do
      role = create :role, full_control: true
      create :role, full_control: false

      expect(Role.full_control).to eq [role]
    end
  end

  describe '#destroy' do
    it 'não deve destruir se for uma função principal' do
      role = create :role, full_control: true

      role.destroy

      expect(Role.all).to eq [role]
    end

    it 'deve destruir se não for uma função principal' do
      role = create :role

      role.destroy

      expect(Role.all).to eq []
    end
  end

  describe '#update' do
    it 'não deve atualizar se for uma função principal' do
      role = create :role, full_control: true

      expect(role.update(description: 'Something')).not_to be true
    end

    it 'deve atualizar se não for uma função principal' do
      role = create :role, full_control: false

      expect(role.update(description: 'Something')).to be true
    end
  end
end
