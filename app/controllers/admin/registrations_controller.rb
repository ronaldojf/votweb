class Admin::RegistrationsController < Devise::RegistrationsController

  def create
    # THERE IS NO REGISTRATION, ONLY PROFILE EDITING
  end

  protected

  def after_update_path_for(resource)
    admin_root_path
  end
end
