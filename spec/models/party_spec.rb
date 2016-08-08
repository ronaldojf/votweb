require 'rails_helper'

RSpec.describe Party, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :abbreviation }
  it { is_expected.to validate_uniqueness_of(:abbreviation).case_insensitive }
  it { is_expected.to have_attached_file(:logo) }
  it { is_expected.to validate_attachment_presence(:logo) }
  it { is_expected.to validate_attachment_content_type(:logo).allowing('image/png', 'image/jpg', 'image/jpeg') }
  it { is_expected.to validate_attachment_size(:logo).less_than(500.kilobytes) }
  it { is_expected.to have_many :councillors }

  describe '.search' do
    subject(:name) { 'Jônh Dóe' }
    subject(:abbreviation) { 'PV' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        party = create :party, name: name

        expect(Party.search(name[0..(name.size / 2).to_i])).to eq [party]
      end

      it 'deve retornar o registro que corresponde ao abbreviation' do
        party = create :party, abbreviation: abbreviation

        expect(Party.search(abbreviation[0..(abbreviation.size / 2).to_i])).to eq [party]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        party = create :party, name: name

        expect(Party.search(name)).to eq [party]
      end

      it 'deve retornar o registro que corresponde ao abbreviation' do
        party = create :party, abbreviation: abbreviation

        expect(Party.search(abbreviation)).to eq [party]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :party, name: name, abbreviation: abbreviation

        expect(Party.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        party = create :party, name: name, abbreviation: abbreviation

        expect(Party.search('')).to eq [party]
      end
    end
  end
end
