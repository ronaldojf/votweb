require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  ensure_security_headers # See more: https://github.com/twitter/secureheaders

  def current_ability
    @current_ability ||= Ability.new(current_administrator)
  end

  def store_controller_config(name, value)
    session[key_for_controller_session] ||= {}
    session[key_for_controller_session][name.to_s] = value
  end

  def get_controller_config(name)
    session[key_for_controller_session].try(:[], name.to_s)
  end

  def clear_controller_config
    session.delete key_for_controller_session
  end

  private

  def layout_by_resource
    if administrator_signed_in?
      'admin/authenticated'
    else
      'admin/application'
    end
  end

  def after_sign_in_path_for(resource)
    url_redirect = resource.is_a?(Administrator) ? admin_root_path : root_path
    request.env['omniauth.origin'] || stored_location_for(resource) || url_redirect
  end

  def after_sign_out_path_for(resource_or_scope)
    new_session_path(resource_or_scope)
  end

  def key_for_controller_session
    namespace = self.class.to_s.deconstantize
    "#{namespace}#{controller_name}"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)        { |u| u.permit() }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end
end
