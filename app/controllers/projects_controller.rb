class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @project = current_user.projects.find(params[:id])
    @events = @project.events.order("created_at DESC").first(50)
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(create_params)
    if current_user.memberships.create(project: project)
      redirect_to project_path(project)
    else
      flash[:error] = project.errors.full_messages
    end
  end

  private

  def create_params
    params.require(:project).permit(:name)
  end
end
