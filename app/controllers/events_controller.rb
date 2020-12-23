class EventsController < ApplicationController

  def index
    @events = Event.all
    Rails.logger.debug "#{@events.inspect}"
    respond_to do |format|
      format.json
    end
  end
  
  def show
  end
  
  def new
  end
  
  def create
    event = Event.new(event_params)
    Rails.logger.debug "Event = #{event.inspect}"
    if event.save
      #EventsChannel.broadcast_to event
      head :ok
    else
      head :ok
    end  
  end
  
  def edit
  end
  
  def update
  end
  
  def delete
  end
  
  def event_params
    params.require(:event).permit(
      :name, :description, :url, :id
    )
  end
end
