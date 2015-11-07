class EventsController < ApplicationController
  def index
    @events = Event.order("created_at DESC").last(50)
  end
end
