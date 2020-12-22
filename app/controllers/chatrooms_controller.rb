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

  def chatroom_details
    @chatroom = Chatroom.find_by_id(params[:id])
    #respond_with(@chatroom)
  end

end
