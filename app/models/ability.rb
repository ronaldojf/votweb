class Ability
  include CanCan::Ability

  def initialize(user)
    return false if user.blank?
    Rails.logger.debug '[Ability] Defining...'

    role_service = RoleService.new
    group = nil

    if user.roles.full_control.exists?
      group = role_service.full_control_group
    else
      group = role_service.agroup_actions_per_subject(user.roles)
    end

    group.try(:each) do |subject, actions|
      Rails.logger.debug "[Ability] #{actions} of #{subject} for (#{user.id}#{' -> ' + user.name if user.try(:name)})"
      begin
        can actions.map(&:to_sym), (subject.constantize rescue nil) || subject.to_s.to_sym
      rescue NameError=>e
        Rails.logger.debug "[Ability] Class #{subject} does not exists - #{e.message}"
      end
    end
  end
end
