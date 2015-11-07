class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @project = Project.find(params[:id])
    @events = @project.events.order("created_at DESC").first(50)
  end
end
