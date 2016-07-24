class Admin::BaseController < ApplicationController
  include IndexTableFilters

  before_action :authenticate_administrator!
  authorize_resource

  layout 'admin/authenticated'
  helper_method :current_user

  def current_user
    current_administrator
  end

  private

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.warn "[Ability] Access denied to #{action_name} in #{controller_name} for (#{current_user.id}#{' -> ' + current_user.name if current_user.try(:name)})"
    redirect_to admin_root_path, alert: I18n.t('errors.custom_messages.unpermited')
  end
end
