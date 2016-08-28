require 'rails_helper'

RSpec.describe SessionMember, type: :model do
  it { is_expected.to be_an ApplicationRecord }
  it { is_expected.to_not validate_presence_of :plenary_session } # EVITAR ERRO NO CRIAR SESSÃO
  it { is_expected.to validate_presence_of :councillor }
  it { is_expected.to belong_to :plenary_session }
  it { is_expected.to belong_to :councillor }
end
