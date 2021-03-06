require 'rails_helper'

RSpec.describe Poll, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :process }
  it { is_expected.to validate_presence_of :plenary_session }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to define_enum_for :process }
  it { is_expected.to belong_to :plenary_session }
  it { is_expected.to have_many :votes }

  it "deve retornar 'duration' como tempo de duração em segundos" do
    poll = build :poll, duration: 5

    expect(poll.duration).to eq 5.seconds
  end

  describe '#stop_countdown' do
    context 'se a data de criação somada à duração ainda for futura' do
      it 'deve alterar a duração para a quantidade de tempo em segundos que se passou desde que o registro foi criado, até que esse método foi executado' do
        Timecop.freeze do
          poll = create :poll, duration: 20

          Timecop.travel 12.seconds.from_now do
            poll.stop_countdown
          end

          expect(poll.reload.duration).to eq 12
        end
      end
    end

    context 'se a data de criação somada à duração já tiver passado' do
      it 'não deve alterar a duração' do
        Timecop.freeze do
          poll = create :poll, duration: 20

          Timecop.travel 22.seconds.from_now do
            poll.stop_countdown
          end

          expect(poll.reload.duration).to eq 20
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

  describe '#add_vote_for' do
    context 'quando a votação estiver aberta' do
      it 'deve adicionar o voto do vereador' do
        Timecop.freeze do
          councillor = create :councillor
          plenary_session = create(:session_member, councillor: councillor).plenary_session
          poll = create :poll, plenary_session: plenary_session, created_at: 8.seconds.ago, duration: 5

          poll.add_vote_for(councillor, :rejection)
          vote = poll.votes.reload.first

          expect(vote.councillor).to eq councillor
          expect(vote).to be_rejection
        end
      end
    end

    context 'quando a votação não estiver aberta' do
      it 'não deve adicionar votos' do
        Timecop.freeze do
          councillor = create :councillor
          plenary_session = create(:session_member, councillor: councillor).plenary_session
          poll = create :poll, plenary_session: plenary_session, created_at: 8.seconds.ago, duration: 4

          poll.add_vote_for(councillor, :approvation)

          expect(poll.votes.reload).to eq []
        end
      end

      context 'quando a votação não estiver aberta e o vereador é o presidente da sessão' do
        it 'deve adicionar o voto do vereador' do
          Timecop.freeze do
            councillor = create :councillor
            plenary_session = create(:session_member, councillor: councillor, is_president: true).plenary_session
            poll = create :poll, plenary_session: plenary_session, created_at: 8.seconds.ago, duration: 4

            poll.add_vote_for(councillor, :rejection)
            vote = poll.votes.reload.first

            expect(vote.councillor).to eq councillor
            expect(vote).to be_rejection
          end
        end
      end
    end

    context 'quando o vereador já tem um voto na votação' do
      it 'não deve adicionar outro voto do mesmo vereador' do
        councillor1 = create :councillor
        councillor2 = create :councillor
        plenary_session = create(:session_member, councillor: councillor1).plenary_session
        create :session_member, plenary_session: plenary_session, councillor: councillor2
        poll = create :poll, plenary_session: plenary_session

        poll.add_vote_for(councillor1, :rejection)
        vote = poll.votes.reload.first

        expect(vote.councillor).to eq councillor1
        expect(poll.votes.count).to eq 1

        poll.add_vote_for(councillor1, :rejection)

        expect(poll.votes.count).to eq 1

        vote = poll.add_vote_for(councillor2, :rejection)

        expect(vote.councillor).to eq councillor2
        expect(poll.votes.count).to eq 2
      end
    end

    context 'quando a votação for secreta' do
      it 'não deve associar o vereador com o voto' do
        councillor = create :councillor
        plenary_session = create(:session_member, councillor: councillor).plenary_session
        poll = create :poll, plenary_session: plenary_session, process: :secret

        poll.add_vote_for(councillor, :approvation)
        vote = poll.votes.reload.first

        expect(vote.councillor).to be_nil
        expect(vote).to be_approvation
      end
    end
  end

  describe '#to_builder' do
    it 'deve retornar uma instância do JBuilder com os principais atributos do objeto' do
      Timecop.freeze do
        plenary_session = create :plenary_session
        poll = build :poll, plenary_session: plenary_session, process: :symbolic, description: nil, duration: 20, created_at: DateTime.current

        expect(poll.to_builder.attributes!).to eq({
          'id' => nil,
          'process' => 'symbolic',
          'plenary_session_id' => plenary_session.id,
          'description' => nil,
          'countdown' => 20,
          'duration' => 20,
          'president_voted' => false,
          'created_at' => DateTime.current,
          'deleted_at' => nil
        })
      end
    end
  end
end
