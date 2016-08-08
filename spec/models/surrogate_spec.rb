require 'rails_helper'

RSpec.describe Surrogate, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :voter_registration }
  it { is_expected.to validate_uniqueness_of :voter_registration }

  describe '.search' do
    subject(:name) { 'Jônh' }
    subject(:voter_registration) { 12.times.map { rand(10) }.join('') }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        surrogate = create :surrogate, name: name

        expect(Surrogate.search(name[0..(name.size / 2).to_i])).to eq [surrogate]
      end

      it 'deve retornar o registro que corresponde ao título de eleitor' do
        surrogate = create :surrogate, voter_registration: voter_registration

        expect(Surrogate.search(voter_registration[0..(voter_registration.size / 2).to_i])).to eq [surrogate]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        surrogate = create :surrogate, name: name

        expect(Surrogate.search(name)).to eq [surrogate]
      end

      it 'deve retornar o registro que corresponde ao título de eleitor' do
        surrogate = create :surrogate, voter_registration: voter_registration

        expect(Surrogate.search(voter_registration)).to eq [surrogate]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :surrogate, name: name, voter_registration: voter_registration

        expect(Surrogate.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        surrogate = create :surrogate, name: name, voter_registration: voter_registration

        expect(Surrogate.search('')).to eq [surrogate]
      end
    end
  end
end
