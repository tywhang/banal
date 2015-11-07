module Api
  class EventsController < ApplicationController
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
      ])
    end
  end
end
