class ChatroomMessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stop_all_streams
    #@chatroom = Chatroom.find(params[:id])
    @chatroom = Chatroom.find(params[:id])
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
    
    # Create Chatroom_membership if it does not exist and set last_read_at
  
    chatroom_membership = ChatroomMembership.find_by_user_id_and_chatroom_id(user.id, @chatroom.id)
    #chatroom_membership = @chatroom.chatroom_memberships.first
    unless chatroom_membership.nil?
      # TODO: Analyze next line 
      chatroom_membership.last_read_at = Time.now
      chatroom_membership.save!
    else
      chatroom_membership = ChatroomMembership.new
      chatroom_membership.user = user
      chatroom_membership.chatroom = @chatroom
      # TODO: Analyze next line 
      chatroom_membership.last_read_at = Time.now
      user.chatroom_memberships << chatroom_membership
      user.save
    end
    data['last_read_at'] = chatroom_membership.last_read_at
    
   
    #{"content":"ssssaaaa","user":"dash5","created_at":"2020-12-19T09:58:53.595Z"}
    #broadcast_data ={content: message.content, user: message.user.username, created_at: message.created_at}
    #if user.profile.avatar.attached?
     # imagejson = {photo: rails_blob_path(user.profile.avatar)}
     # broadcast_data.merge(imagejson)
    #end
    # Broadcast message data
    ChatroomMessagesChannel.broadcast_to(@chatroom, {chatroomId: @chatroom.id, content: message.content, username: message.user.username, created_at: message.created_at})

    #	participantimagejson = {photo: rails_blob_path(@participant.profile.avatar)}

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
