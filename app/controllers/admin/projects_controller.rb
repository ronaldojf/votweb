class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @projects = scope_for_ng_table(Project)
                            .includes(:author)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.save
    respond_with :admin, @project
  end

  def update
    @project.update(project_params)
    respond_with :admin, @project
  end

  def destroy
    @project.destroy
    respond_with @project, location: -> { admin_projects_path }
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params
      .require(:project)
      .permit(:title, :councillor_id)
  end
end
