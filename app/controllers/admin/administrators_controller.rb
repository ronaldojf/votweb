class Admin::AdministratorsController < Admin::BaseController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @administrators = scope_for_ng_table(Administrator)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @administrator = Administrator.new
  end

  def edit
    if current_administrator == @administrator
      redirect_to edit_registration_path(current_administrator)
    elsif @administrator.main?
      redirect_to(admin_administrator_path(@administrator), alert: I18n.t('flash.actions.edit.alerts.editing_main_administrator'))
    end
  end

  def create
    @administrator = Administrator.new(administrator_params)
    @administrator.save
    respond_with :admin, @administrator
  end

  def update
    unless @administrator.main?
      @administrator.update(administrator_params) if @administrator != current_administrator
    end

    respond_with :admin, @administrator
  end

  def destroy
    if @administrator.id == current_user.id
      redirect_to [:admin, @administrator], alert: t('flash.actions.destroy.alerts.self_destroy')
    elsif @administrator.main
      redirect_to [:admin, @administrator], alert: I18n.t('flash.actions.destroy.alerts.main_administrator')
    else
      @administrator.destroy
      redirect_to admin_administrators_path, notice: t('flash.actions.destroy.notice')
    end
  end

  def unlock
    @administrator.unlock_access!
    respond_with :admin, @administrator
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    result = params
              .require(:administrator)
              .permit(:name, :email, :password, :password_confirmation, role_ids: [])

    if result[:password].blank?
      result.delete(:password)
      result.delete(:password_confirmation)
    end

    result
  end
end
