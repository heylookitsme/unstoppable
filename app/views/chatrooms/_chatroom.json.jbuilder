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

last_read_at = chatroom.chatroom_memberships.first.last_read_at
last_read_at_json =  {last_read_at: last_read_at}
json.merge!  last_read_at_json