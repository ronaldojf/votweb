require 'rails_helper'

RSpec.describe Alderman, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :voter_registration }
  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_presence_of :party }
  it { is_expected.to have_attached_file(:avatar) }
  it { is_expected.to validate_attachment_presence(:avatar) }
  it { is_expected.to validate_attachment_content_type(:avatar).allowing('image/png', 'image/jpg', 'image/jpeg') }
  it { is_expected.to validate_attachment_size(:avatar).less_than(5.megabytes) }
  it { is_expected.to define_enum_for :gender }
  it { is_expected.to belong_to :party }

  describe '.search' do
    subject(:name) { 'Jônh' }
    subject(:voter_registration) { 12.times.map { rand(10) }.join('') }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        alderman = create :alderman, name: name

        expect(Alderman.search(name[0..(name.size / 2).to_i])).to eq [alderman]
      end

      it 'deve retornar o registro que corresponde ao título de eleitor' do
        alderman = create :alderman, voter_registration: voter_registration

        expect(Alderman.search(voter_registration[0..(voter_registration.size / 2).to_i])).to eq [alderman]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        alderman = create :alderman, name: name

        expect(Alderman.search(name)).to eq [alderman]
      end

      it 'deve retornar o registro que corresponde ao título de eleitor' do
        alderman = create :alderman, voter_registration: voter_registration

        expect(Alderman.search(voter_registration)).to eq [alderman]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :alderman, name: name, voter_registration: voter_registration

        expect(Alderman.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        alderman = create :alderman, name: name, voter_registration: voter_registration

        expect(Alderman.search('')).to eq [alderman]
      end
    end
  end

  describe '.by_gender' do
    context 'quando o sexo é passado' do
      it 'retorna os registros do sexo passado' do
        alderman = create :alderman, gender: :male
        alderwoman = create :alderman, gender: :female

        expect(Alderman.by_gender('female')).to eq [alderwoman]
      end
    end

    context 'quando o sexo não é passado' do
      it 'deve retornar todos os registros' do
        alderman = create :alderman, gender: :male

        expect(Alderman.by_gender('')).to eq [alderman]
      end
    end
  end

  describe '.by_party' do
    context 'quando o partido é passado' do
      it 'retorna os registros do partido passado' do
        party = create(:party)
        alderman1 = create :alderman, party: party
        alderman2 = create :alderman

        expect(Alderman.by_party(party.id)).to eq [alderman1]
      end
    end

    context 'quando o partido não é passado' do
      it 'deve retornar todos os registros' do
        alderman = create :alderman

        expect(Alderman.by_party('')).to eq [alderman]
      end
    end
  end
end
