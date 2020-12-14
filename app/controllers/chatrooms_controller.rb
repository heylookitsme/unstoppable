class ChatroomsController < ApplicationController

  def index
    @chatrooms = Chatroom.all
    #respond_with(@chatrooms)
  end

  def show
    @chatroom = Chatroom.find_by_id(params[:id])
    #respond_with(@chatroom)
  end

end
