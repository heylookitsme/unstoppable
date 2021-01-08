class ChatroomsController < ApplicationController
  respond_to :json, :html

  def index
    @chatrooms = Chatroom.all
    #respond_with(@chatrooms)
  end

  def show
    @chatroom = Chatroom.find_by_id(params[:id])
    #respond_with(@chatroom)
  end

  def create
    chatroom = Chatroom.new(chatroom_params)
    Rails.logger.debug "Chatoom = #{chatroom.inspect}"
    if chatroom.save
      head :ok
    else
      head :ok
    end  
  end

  def chatroom_details
    @chatroom = Chatroom.find_by_id(params[:id])
    current_user.chatroom_memberships.each do |c|
      if c.chatroom.id == @chatroom.id
        c.last_read_at = Time.now
        c.save!
      end
    end
    #respond_with(@chatroom)
  end

  def chatroom_params
    params.require(:chatroom).permit(
      :name, :description
    )
  end
end
