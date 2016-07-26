require 'rails_helper'

RSpec.describe Administrator, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_and_belong_to_many :roles }

  describe '.search' do
    subject(:name) { 'Jônh' }
    subject(:email) { 'jòhndoé@hõtmail.com' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        administrator = create :administrator, name: name

        expect(Administrator.search(name[0..(name.size / 2).to_i])).to eq [administrator]
      end

      it 'deve retornar o registro que corresponde ao email' do
        administrator = create :administrator, email: email

        expect(Administrator.search(email[0..(email.size / 2).to_i])).to eq [administrator]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        administrator = create :administrator, name: name

        expect(Administrator.search(name)).to eq [administrator]
      end

      it 'deve retornar o registro que corresponde ao email' do
        administrator = create :administrator, email: email

        expect(Administrator.search(email)).to eq [administrator]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :administrator, name: name, email: email

        expect(Administrator.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        administrator = create :administrator, name: name, email: email

        expect(Administrator.search('')).to eq [administrator]
      end
    end
  end

  describe '.can' do
    context 'quando houver um administrador com uma função de controle total' do
      it 'deve sempre retornar o administrador' do
        administrator = create :administrator, roles: [create(:role, full_control: true)]

        expect(Administrator.can(:whatever, Administrator)).to eq [administrator]
      end
    end

    context 'quando uma permissão existente é passada' do
      it 'deve retornar os administradores que possuem essa permissão' do
        administrator1 = create(:administrator, roles: [
          create(:role, permissions: [
            create(:permission, subject: Administrator.to_s, actions: [:write]),
            create(:permission, subject: Administrator.to_s, actions: [:read])
          ])
        ])
        administrator2 = create(:administrator, roles: [
          create(:role, permissions: [create(:permission, subject: Administrator.to_s, actions: [:write])]),
          create(:role, permissions: [create(:permission, subject: Administrator.to_s, actions: [:read])])
        ])
        create :administrator, roles: [create(:role, permissions: [create(:permission, subject: Administrator.to_s, actions: [:whatever])])]

        expect(Administrator.can(:read, Administrator).order(:id)).to eq [administrator1, administrator2]
      end
    end
  end

  describe '#destroy' do
    it 'não exclui se for um administrador principal' do
      administrator = create :administrator, main: true

      administrator.destroy

      expect(Administrator.all).to eq [administrator]
    end

    it 'deve excluir se não for um administrador principal' do
      administrator = create :administrator, main: false

      administrator.destroy

      expect(Administrator.all).to eq []
    end
  end
end
