class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :reset_token]

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
      flash[:alert] = project.errors.full_messages
    end
  end

  def reset_token
    if params[:project_id].to_i == Project.demo.id
      flash[:alert] = "Sorry, you cannot reset the token for the demo project"
      redirect_to project_path(Project.demo)
    elsif !user_signed_in?
      authenticate_user!
    else
      project = current_user.projects.find(params[:project_id])
      if project.reset_token!
        flash[:notice] = "Project '#{project.name}' token reset"
      else
        flash[:alert] = "Could not reset token for project '#{project.name}'"
      end
      redirect_to project_path(project)
    end
  end

  private

  def create_params
    params.require(:project).permit(:name)
  end
end
