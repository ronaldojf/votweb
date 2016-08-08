require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :author }
  it { is_expected.to belong_to :author }

  describe '.search' do
    subject(:title) { 'Projeto de reformas da rodovia BR-156' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        project = create :project, title: title

        expect(Project.search(title[0..(title.size / 2).to_i])).to eq [project]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        project = create :project, title: title

        expect(Project.search(title)).to eq [project]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :project, title: title

        expect(Project.search('234f9vc8nu28933918')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        project = create :project, title: title

        expect(Project.search('')).to eq [project]
      end
    end
  end
end
