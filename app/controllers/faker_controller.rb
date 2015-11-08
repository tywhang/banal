class FakerController < ApplicationController
  before_filter :load_project

  def new
    @event = @project.events.build
    respond_to do |format|
      format.js { render 'new', layout: false }
      format.html
    end
  end

  def create
    @event = @project.events.create(event_params)
    if @event.persisted?
      Event.__elasticsearch__.client.indices.refresh index: Event.index_name
      redirect_to @event.project
    else
      flash[:alert] = "couldn't create event"
      render :new
    end
  end

  private

  def load_project
    if params[:project_id].to_s == (demo = Project.find_by!(name: Project::DEMO_NAME)).id.to_s
      @project = demo
    else
      @project = current_user.projects.find(params[:project_id])
    end
  end

  def event_params
    eparams = params.require(:event)
    {
      actor:      eparams[:actor],
      verb:       eparams[:verb],
      object:     eparams[:object],
      target:     eparams[:target],
      project_id: @project.id
    }
  end
end
