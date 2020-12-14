class ChatroomMessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stop_all_streams
    #@chatroom = Chatroom.find(params[:id])
    @chatroom = Chatroom.find(1)
    Rails.logger.debug "In subscribed"
    #stream_from @chatroom
    stream_for @chatroom
  end

  def receive(data)
    Rails.logger.debug "ChatroomMessagesChannel:receive data = #{data.inspect}"
    @chatroom = Chatroom.find(data['chatroomId'])
    Rails.logger.debug "ChatroomMessagesChannel:receive @chatroom = #{@chatroom.inspect}"
    user = User.find(data['userId'].to_i)
    Rails.logger.debug "ChatroomMessagesChannel:receive user = #{user.inspect}"
    message = @chatroom.chatroom_messages.create(content: data['content'], user: user)
    Rails.logger.debug "ChatroomMessagesChannel:receive message = #{message.inspect}"
    ChatroomMessagesChannel.broadcast_to(@chatroom, data)
    #sleep(30)
    #ChatroomMessagesChannel.broadcast_to(@chatroom, data )
    #sleep(30)
    #ChatroomMessagesChannel.broadcast_to(@chatroom, {name: "Yabbs"} )
    #sleep(30)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
