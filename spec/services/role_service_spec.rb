require 'rails_helper'

RSpec.describe RoleService, type: :service do
  subject { RoleService.new }

  describe '#modules' do
    let(:valid_role_service) { RoleService.new('spec/fixtures/permissions/valid_permissions.yml') }

    it 'deve retornar todos os módulos em um arquivo YML' do
      expect(valid_role_service.modules).to eq(['Administrator', 'Deliveryman'])
    end

    it 'deve retornar todas as ações' do
      expect(valid_role_service.actions('Administrator')).to eq(['create', 'update', 'destroy', 'read', 'another'])
      expect(valid_role_service.actions('Deliveryman')).to eq(['create', 'update', 'destroy', 'read'])
    end

    it 'deve retornar um array vazio quando o parâmetro não é válido' do
      expect(valid_role_service.actions('INVALID')).to eq([])
      expect(valid_role_service.actions('')).to eq([])
      expect(valid_role_service.actions(nil)).to eq([])
    end
  end
end
