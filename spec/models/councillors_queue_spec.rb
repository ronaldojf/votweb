require 'rails_helper'

RSpec.describe CouncillorsQueue, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  describe '#add_to_queue' do
    context 'quando for passado um vereador que ainda não foi adicionado à fila' do
      it 'deve adicionar o vereador à fila' do
        queue = create :councillors_queue
        councillor1 = create :councillor
        councillor2 = create :councillor

        queue.add_to_queue(councillor2)
        queue.add_to_queue(councillor1.id)

        expect(queue.reload.councillors_ids).to eq [councillor2.id, councillor1.id]
      end
    end

    context 'quando um vereador que já foi adicionado à fila for passado' do
      it 'não deve adicionar o vereador à fila' do
        queue = create :councillors_queue
        councillor1 = create :councillor
        councillor2 = create :councillor

        queue.add_to_queue(councillor1)
        queue.add_to_queue(councillor2)
        queue.add_to_queue(councillor1)

        expect(queue.reload.councillors_ids).to eq [councillor1.id, councillor2.id]
      end
    end

    context 'quando nada for passado' do
      it 'não deve adicionar o vereador à fila' do
        queue = create :councillors_queue

        queue.add_to_queue(nil)

        expect(queue.reload.councillors_ids).to eq []
      end
    end
  end

  describe '#councillors' do
    it 'deve retornar os vereadores em ordem de inclusão na fila' do
      queue = create :councillors_queue
      councillor1 = create :councillor
      councillor2 = create :councillor
      councillor3 = create :councillor
      councillor4 = create :councillor

      queue.add_to_queue(councillor3)
      queue.add_to_queue(councillor2)
      queue.add_to_queue(councillor1)
      queue.add_to_queue(councillor4)

      expect(queue.reload.councillors).to eq [councillor3, councillor2, councillor1, councillor4]
    end
  end
end
