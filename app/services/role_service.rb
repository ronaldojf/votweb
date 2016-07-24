class RoleService
  KEYS_DEFAULTS = ['default_actions']
  attr_reader :yml

  def initialize(file = 'config/permissions.yml')
    if Rails.env.production?
      @@cache_yml ||= load_yml(file)
      @yml = @@cache_yml
    end
    @yml ||= load_yml(file)
  end

  def modules
    @yml.keys.reject { |key| KEYS_DEFAULTS.include?(key) }
  end

  def actions(modul)
    @yml[modul].to_a.inject([]) do |result, action|
      result += if action.is_a?(Array)
        action
      else
        [action]
      end
      result
    end
  end

  def agroup_actions_per_subject(roles)
    group = []

    roles.each do |role|
      group << role.permissions.to_a.inject({}) do |result, permission|
        result[permission.subject] ||= []
        permission.actions.select(&:present?).each { |action| result[permission.subject] << action }
        result
      end

      group << role.permissions.to_a.inject({}) do |result, permission|
        result[permission.subject] ||= []
        permission.actions.select(&:present?).each { |action| result[permission.subject] << action }
        result
      end
    end

    group.inject(&:merge)
  end

  def full_control_group
    @yml.except(*KEYS_DEFAULTS).collect { |k, v| { k => v } }.inject(&:merge)
  end

  private

  def load_yml(file)
    YAML.load_file(File.join(Rails.root, file))
  end
end
