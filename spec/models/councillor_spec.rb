require 'rails_helper'

RSpec.describe Councillor, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :party }
  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  it { is_expected.to belong_to :party }

  describe '.search' do
    subject(:name) { 'Jônh' }
    subject(:username) { 'johntitor' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        councillor = create :councillor, name: name

        expect(Councillor.search(name[0..(name.size / 2).to_i])).to eq [councillor]
      end

      it 'deve retornar o registro que corresponde ao nome de usuário' do
        councillor = create :councillor, username: username

        expect(Councillor.search(username[0..(username.size / 2).to_i])).to eq [councillor]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        councillor = create :councillor, name: name

        expect(Councillor.search(name)).to eq [councillor]
      end

      it 'deve retornar o registro que corresponde ao nome de usuário' do
        councillor = create :councillor, username: username

        expect(Councillor.search(username)).to eq [councillor]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :councillor, name: name, username: username

        expect(Councillor.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        councillor = create :councillor, name: name, username: username

        expect(Councillor.search('')).to eq [councillor]
      end
    end
  end

  describe '.by_party' do
    context 'quando o partido é passado' do
      it 'retorna os registros do partido passado' do
        party = create(:party)
        councillor1 = create :councillor, party: party
        councillor2 = create :councillor

        expect(Councillor.by_party(party.id)).to eq [councillor1]
      end
    end

    context 'quando o partido não é passado' do
      it 'deve retornar todos os registros' do
        councillor = create :councillor

        expect(Councillor.by_party('')).to eq [councillor]
      end
    end
  end

  describe '.active' do
    it 'deve retornar somente vereadores ativos' do
      councillor1 = create :councillor, is_active: true
      councillor2 = create :councillor, is_active: false

      expect(Councillor.active).to eq [councillor1]
    end
  end

  describe '.holder' do
    it 'deve retornar somente vereadores titulares' do
      councillor1 = create :councillor, is_holder: true
      councillor2 = create :councillor, is_holder: false

      expect(Councillor.holder).to eq [councillor1]
    end
  end

  describe '.surrogate' do
    it 'deve retornar somente vereadores suplentes' do
      councillor1 = create :councillor, is_holder: true
      councillor2 = create :councillor, is_holder: false

      expect(Councillor.surrogate).to eq [councillor2]
    end
  end

  describe '#email_required?' do
    it 'deve ser falso' do
      councillor = build :councillor
      expect(councillor.email_required?).to be false
    end
  end

  describe '#email_changed?' do
    it 'deve ser falso' do
      councillor = build :councillor
      expect(councillor.email_changed?).to be false
    end
  end

  describe '.by_active' do
    context "quando for passado 'true'" do
      it 'deve retornar todos os vereadores ativos' do
        councillor1 = create :councillor, is_active: true
        councillor2 = create :councillor, is_active: false

        expect(Councillor.by_active('true')).to eq [councillor1]
        expect(Councillor.by_active(true)).to eq [councillor1]
      end
    end

    context "quando for passado algo além de 'true'" do
      it 'deve retornar todos os vereadores inativos' do
        councillor1 = create :councillor, is_active: true
        councillor2 = create :councillor, is_active: false

        expect(Councillor.by_active('false')).to eq [councillor2]
        expect(Councillor.by_active(false)).to eq [councillor2]
        expect(Councillor.by_active('other')).to eq [councillor2]
      end
    end

    context "quando nada for passado" do
      it 'deve retornar todos os registros' do
        councillor1 = create :councillor, is_active: true
        councillor2 = create :councillor, is_active: false

        expect(Councillor.by_active('')).to include(councillor1, councillor2)
      end
    end
  end

  describe '.by_holder' do
    context "quando for passado 'true'" do
      it 'deve retornar todos os vereadores titulares' do
        councillor1 = create :councillor, is_holder: true
        councillor2 = create :councillor, is_holder: false

        expect(Councillor.by_holder('true')).to eq [councillor1]
        expect(Councillor.by_holder(true)).to eq [councillor1]
      end
    end

    context "quando for passado algo além de 'true'" do
      it 'deve retornar todos os vereadores suplentes' do
        councillor1 = create :councillor, is_holder: true
        councillor2 = create :councillor, is_holder: false

        expect(Councillor.by_holder('false')).to eq [councillor2]
        expect(Councillor.by_holder(false)).to eq [councillor2]
        expect(Councillor.by_holder('other')).to eq [councillor2]
      end
    end

    context "quando nada for passado" do
      it 'deve retornar todos os registros' do
        councillor1 = create :councillor, is_holder: true
        councillor2 = create :councillor, is_holder: false

        expect(Councillor.by_holder(nil)).to include(councillor1, councillor2)
      end
    end
  end
end
