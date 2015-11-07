class EventsController < ApplicationController
  def index
    @events = Event.order("created_at DESC").first(50)
  end
end
