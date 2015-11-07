module Api
  class EventsController < ApplicationController
    rescue_from 'ActiveRecord::RecordNotFound' do |exception|
      render status: :not_found, json: {}
    end

    def create
      event = Event.new(create_params)
      if event.save
        render status: :created, json: {}
      else
        render status: :unprocessable, json: { errors: event.errors.full_messages }
      end
    end

    private

    def create_params
      params.permit([
        {actor: [:id, :name]},
        :verb,
        {object: [:id, :name]},
        {target: [:id, :name]}
      ]).merge(project_id: current_project.id)
    end

    def current_project
      Project.find_by!(token: request.headers['X-AUTHTOKEN'])
    end
  end
end
