json.extract! chatroom, :id, :name, :description

#messages = chatroom.chatroom_messages.blank? ? []: chatroom.chatroom_messages.collect{|x| x.content}
#messages_json =  {messages: messages}
#json.merge!  messages_json

messages = []
unless chatroom.chatroom_messages.blank?
  chatroom.chatroom_messages.each do |c|
    m = {content: c.content, username: c.user.username, created_at: c.created_at}
    messages <<  m
  end
end
messages_json =  {messages: messages}
json.merge!  messages_json

members = []
unless chatroom.chatroom_memberships.blank?
  chatroom.chatroom_memberships.each do |chatroom_membership|
    if chatroom_membership.user.profile.avatar.attached?
			avatar = {photo: rails_blob_path(chatroom_membership.user.profile.avatar)}
    else
      avatar = {photo: ""}
    end
    m = {username: chatroom_membership.user.username, photo: avatar}
    members <<  m
  end
end
members_json =  {members: members}
json.merge!  members_json

last_read_at = nil
unless chatroom.chatroom_memberships.blank?
  chatroom_membership = ChatroomMembership.find_by_user_id_and_chatroom_id(current_user.id, chatroom.id)
  last_read_at = chatroom_membership.last_read_at unless chatroom_membership.nil?
end
last_read_at_json =  {last_read_at: last_read_at}
json.merge!  last_read_at_json