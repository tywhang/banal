class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    if !user_signed_in?
      if params[:id].to_i == Project.demo.id
        @project = Project.demo
      else
        redirect_to new_user_session_path
        return
      end
    else
      @project = current_user.projects.find(params[:id])
    end

    @project = Project.find(params[:id])
    @search = Search.new((params.slice(:q) || {}).merge(project: @project))
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
