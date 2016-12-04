require 'rails_helper'

RSpec.describe PlenarySession, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_presence_of :start_at }
  it { is_expected.to define_enum_for :kind }
  it { is_expected.to have_many :polls }
  it { is_expected.to have_many :members }
  it { is_expected.to have_many :items }
  it { is_expected.to have_many :queues }
  it { is_expected.to have_many :countdowns }
  it { is_expected.to accept_nested_attributes_for :members }

  describe '.search' do
    subject(:title) { 'Sessão 12.542 - 2016' }

    context 'quando metade do valor de um atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search(title[0..(title.size / 2).to_i])).to eq [plenary_session]
      end
    end

    context 'quando o valor completo do atributo é passado' do
      it 'deve retornar o registro que corresponde ao nome' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search(title)).to eq [plenary_session]
      end
    end

    context 'quando algo que não vai ser encontrado é passado' do
      it 'não retorna nenhum registro' do
        create :plenary_session, title: title

        expect(PlenarySession.search('2339184f9vc8nu2893')).to eq []
      end
    end

    context 'quando nada é passado' do
      it 'retorna todos os registros' do
        plenary_session = create :plenary_session, title: title

        expect(PlenarySession.search('')).to eq [plenary_session]
      end
    end
  end

  describe '.not_test' do
    it 'deve retornar todas as sessão que não forem de teste' do
      plenary_session1 = create :plenary_session, is_test: true
      plenary_session2 = create :plenary_session, is_test: false

      expect(PlenarySession.not_test).to eq [plenary_session2]
    end
  end

  describe '.by_kind' do
    let!(:ordinary) { create :plenary_session, kind: :ordinary }
    let!(:extraordinary) { create :plenary_session, kind: :extraordinary }
    let!(:solemn) { create :plenary_session, kind: :solemn }
    let!(:special) { create :plenary_session, kind: :special }

    context "quando for passado o tipo 'ordinary'" do
      it 'deve retornar somente sessões ordinárias' do
        expect(PlenarySession.by_kind('ordinary')).to eq [ordinary]
        expect(PlenarySession.by_kind(:ordinary)).to eq [ordinary]
      end
    end

    context "quando for passado o tipo 'extraordinary'" do
      it 'deve retornar somente sessões extraordinárias' do
        expect(PlenarySession.by_kind('extraordinary')).to eq [extraordinary]
        expect(PlenarySession.by_kind(:extraordinary)).to eq [extraordinary]
      end
    end

    context "quando for passado o tipo 'solemn'" do
      it 'deve retornar somente sessões solenes' do
        expect(PlenarySession.by_kind('solemn')).to eq [solemn]
        expect(PlenarySession.by_kind(:solemn)).to eq [solemn]
      end
    end

    context "quando for passado o tipo 'special'" do
      it 'deve retornar somente sessões especiais' do
        expect(PlenarySession.by_kind('special')).to eq [special]
        expect(PlenarySession.by_kind(:special)).to eq [special]
      end
    end

    context 'quando nada for passado' do
      it 'deve retornar todos os tipos de sessões' do
        expect(PlenarySession.by_kind(nil)).to include(ordinary, extraordinary, solemn, special)
        expect(PlenarySession.by_kind('')).to include(ordinary, extraordinary, solemn, special)
      end
    end
  end

  describe '.by_test' do
    context "quando for passado 'true'" do
      it 'deve retornar todos os vereadores titulares' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test('true')).to eq [plenary_session1]
        expect(PlenarySession.by_test(true)).to eq [plenary_session1]
      end
    end

    context "quando for passado algo além de 'true'" do
      it 'deve retornar todos os vereadores suplentes' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test('false')).to eq [plenary_session2]
        expect(PlenarySession.by_test(false)).to eq [plenary_session2]
        expect(PlenarySession.by_test('other')).to eq [plenary_session2]
      end
    end

    context "quando nada for passado" do
      it 'deve retornar todos os registros' do
        plenary_session1 = create :plenary_session, is_test: true
        plenary_session2 = create :plenary_session, is_test: false

        expect(PlenarySession.by_test(nil)).to include(plenary_session1, plenary_session2)
      end
    end
  end

  describe '.starts_today' do
    it 'deve retornar somente sessões que iniciem hoje' do
      Timecop.freeze do
        session1 = create :plenary_session, start_at: 1.day.ago
        session2 = create :plenary_session, start_at: DateTime.current.at_beginning_of_day
        session3 = create :plenary_session, start_at: DateTime.current
        session4 = create :plenary_session, start_at: DateTime.current.at_end_of_day
        session5 = create :plenary_session, start_at: 1.day.from_now

        expect(PlenarySession.starts_today).to include(session2, session3, session4)
        expect(PlenarySession.starts_today).to_not include(session1, session5)
      end
    end
  end

  describe '.has_member' do
    it 'deve retornar somente sessões onde o vereador passado é um participante' do
      councillor1 = create :councillor
      councillor2 = create :councillor
      session1 = create :plenary_session
      session2 = create :plenary_session
      create :session_member, councillor: councillor1, plenary_session: session1
      create :session_member, councillor: councillor2, plenary_session: session2

      expect(PlenarySession.has_member(councillor1)).to eq [session1]
      expect(PlenarySession.has_member(councillor2)).to eq [session2]
    end
  end

  describe '#check_members_attendance' do
    it 'deve avaliar todas as votações e chamadas e marcar falta para os membros que faltaram em alguma votação ou chamada, exceto o presidente' do
      plenary_session = create :plenary_session
      councillor1 = create :councillor
      councillor2 = create :councillor
      councillor3 = create :councillor
      councillor4 = create :councillor
      councillor5 = create :councillor
      councillor6 = create :councillor
      member1 = create :session_member, plenary_session: plenary_session, councillor: councillor1, is_president: true, is_present: nil
      member2 = create :session_member, plenary_session: plenary_session, councillor: councillor2, is_president: false, is_present: nil
      member3 = create :session_member, plenary_session: plenary_session, councillor: councillor3, is_president: false, is_present: nil
      member4 = create :session_member, plenary_session: plenary_session, councillor: councillor4, is_president: false, is_present: nil
      member5 = create :session_member, plenary_session: plenary_session, councillor: councillor5, is_president: false, is_present: nil
      member6 = create :session_member, plenary_session: plenary_session, councillor: councillor6, is_president: false, is_present: nil


      poll1 = create :poll, plenary_session: plenary_session, process: :symbolic
      create :vote, poll: poll1, councillor: councillor2
      create :vote, poll: poll1, councillor: councillor3
      create :vote, poll: poll1, councillor: councillor4
      create :vote, poll: poll1, councillor: councillor6
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be true
      expect(member3.reload.is_present).to be true
      expect(member4.reload.is_present).to be true
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be true


      poll2 = create :poll, plenary_session: plenary_session, process: :secret # Votação secreta não conta
      create :vote, poll: poll2
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be true
      expect(member3.reload.is_present).to be true
      expect(member4.reload.is_present).to be true
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be true


      poll3 = create :poll, plenary_session: plenary_session, process: :symbolic
      create :vote, poll: poll3, councillor: councillor2
      create :vote, poll: poll3, councillor: councillor5
      create :vote, poll: poll3, councillor: councillor6
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be true
      expect(member3.reload.is_present).to be false
      expect(member4.reload.is_present).to be false
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be true


      create :councillors_queue, plenary_session: plenary_session, kind: :attendance, councillors_ids: [councillor2.id]
      create :councillors_queue, plenary_session: plenary_session, councillors_ids: [] # Se não for chamada, não conta
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be true
      expect(member3.reload.is_present).to be false
      expect(member4.reload.is_present).to be false
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be false


      # Sobrescreve todos os resultados anteriores
      create :councillors_queue, plenary_session: plenary_session, kind: :attendance, override_attendance: true, councillors_ids: [councillor3.id, councillor4.id, councillor5.id]
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be false
      expect(member3.reload.is_present).to be true
      expect(member4.reload.is_present).to be true
      expect(member5.reload.is_present).to be true
      expect(member6.reload.is_present).to be false


      poll4 = create :poll, plenary_session: plenary_session, process: :symbolic
      create :vote, poll: poll4, councillor: councillor4
      create :vote, poll: poll4, councillor: councillor5
      create :vote, poll: poll4, councillor: councillor6
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be false
      expect(member3.reload.is_present).to be false
      expect(member4.reload.is_present).to be true
      expect(member5.reload.is_present).to be true
      expect(member6.reload.is_present).to be false


      create :councillors_queue, plenary_session: plenary_session, kind: :attendance, councillors_ids: [councillor4.id]
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be false
      expect(member3.reload.is_present).to be false
      expect(member4.reload.is_present).to be true
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be false


      # Sobrescreve todos os resultados anteriores
      create :councillors_queue, plenary_session: plenary_session, kind: :attendance, override_attendance: true, councillors_ids: [councillor2.id]
      plenary_session.reload.check_members_attendance

      expect(member1.reload.is_present).to be true
      expect(member2.reload.is_present).to be true
      expect(member3.reload.is_present).to be false
      expect(member4.reload.is_present).to be false
      expect(member5.reload.is_present).to be false
      expect(member6.reload.is_present).to be false
    end
  end
end
