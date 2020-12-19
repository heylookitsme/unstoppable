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

    # Get the current Chatroom
    Rails.logger.debug "ChatroomMessagesChannel:receive data = #{data.inspect}"
    @chatroom = Chatroom.find(data['chatroomId'].to_i)
    Rails.logger.debug "ChatroomMessagesChannel:receive @chatroom = #{@chatroom.inspect}"

    # Get the user 
    user = User.find(data['userId'].to_i)
    Rails.logger.debug "ChatroomMessagesChannel:receive user = #{user.inspect}"

    # Get content of Message and save data
    content = data['content']
    message = @chatroom.chatroom_messages.create(content: data['content'], user: user) unless content.blank?
    Rails.logger.debug "ChatroomMessagesChannel:receive message = #{message.inspect}" unless content.blank?
    
    # Set last_read_at
    chatroom_membership = @chatroom.chatroom_memberships.first
    chatroom_membership.last_read_at = Time.now
    chatroom_membership.save
    data['last_read_at'] = chatroom_membership.last_read_at
    
    # Broadcast message data
    ChatroomMessagesChannel.broadcast_to(@chatroom, data)

    
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
