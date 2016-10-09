require 'rails_helper'

RSpec.describe CouncillorsQueue, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to belong_to :plenary_session }

  it "deve retornar 'duration' como tempo de duração em segundos" do
    queue = build :councillors_queue, duration: 5

    expect(queue.duration).to eq 5.seconds
  end

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

  describe '#stop_countdown' do
    context 'se a data de criação somada à duração ainda for futura' do
      it 'deve alterar a duração para a quantidade de tempo em segundos que se passou desde que o registro foi criado, até que esse método foi executado' do
        Timecop.freeze do
          queue = create :councillors_queue, duration: 20

          Timecop.travel 12.seconds.from_now do
            queue.stop_countdown
          end

          expect(queue.reload.duration).to eq 12
        end
      end
    end

    context 'se a data de criação somada à duração já tiver passado' do
      it 'não deve alterar a duração' do
        Timecop.freeze do
          queue = create :councillors_queue, duration: 20

          Timecop.travel 22.seconds.from_now do
            queue.stop_countdown
          end

          expect(queue.reload.duration).to eq 20
        end
      end
    end
  end

  describe '#open?' do
    it "deve retornar 'true' se a votação estiver aberta, contando com os 3 segundos de folga para fechar" do
      Timecop.freeze do
        poll1 = build :poll, created_at: 8.seconds.ago, duration: 4
        poll2 = build :poll, created_at: 8.seconds.ago, duration: 5
        poll3 = build :poll, created_at: 8.seconds.ago, duration: 6

        expect(poll1).to_not be_open
        expect(poll2).to be_open
        expect(poll3).to be_open
      end
    end
  end

  describe '#to_builder' do
    it 'deve retornar uma instância do JBuilder com os principais atributos do objeto' do
      Timecop.freeze do
        queue = build :councillors_queue, description: nil, councillors_ids: [], duration: 20, created_at: DateTime.current

        expect(queue.to_builder.attributes!).to eq({
          "id"=>nil,
          "description"=>nil,
          "countdown"=>20,
          "duration"=>20,
          "councillors_ids"=>[],
          "created_at"=> DateTime.current
        })
      end
    end
  end
end
