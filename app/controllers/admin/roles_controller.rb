class Admin::RolesController < Admin::BaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :set_role_service, only: [:show]
  before_action :normalize_actions!, only: [:update]

  def index
    respond_to do |format|
      format.html
      format.json do
        @roles = scope_for_ng_table(Role)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @role = Role.new
    populate_permissions
  end

  def edit
    if @role.full_control
      redirect_to(admin_role_path(@role), alert: I18n.t('flash.actions.edit.alerts.full_control_role'))
    else
      populate_permissions
    end
  end

  def create
    @role = Role.new(role_params)
    normalize_actions!
    @role.save
    respond_with :admin, @role
  end

  def update
    @role.update(role_params)
    respond_with :admin, @role
  end

  def destroy
    if @role.full_control?
      redirect_to [:admin, @role], alert: I18n.t('flash.actions.destroy.alerts.full_control_role')
    else
      @role.destroy
      redirect_to admin_roles_path, notice: t('flash.actions.destroy.notice')
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params
      .require(:role)
      .permit(:description, permissions_attributes: [:id, :subject, actions: []])
  end

  def set_role_service
    @role_service ||= RoleService.new
  end

  def populate_permissions
    set_role_service

    if @role.persisted?
      @role.permissions.each do |permission|
        permission.destroy if @role_service.modules.exclude?(permission.subject)
      end
      @role.permissions.reload
    end

    @role_service.modules.each do |subject|
      if @role.permissions.collect(&:subject).exclude?(subject.to_s)
        @role.permissions.build(subject: subject.to_s)
      end
    end
  end

  def normalize_actions!
    set_role_service

    @role.permissions.each do |permission|
      actions = @role_service.actions(permission.subject)

      permission.actions.reject! do |action|
        actions.exclude?(action)
      end
    end
  end
end
