module Api
  class EventsController < ActionController::API
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
      params.permit(:actor, :verb, :object, :target)
    end
  end
end