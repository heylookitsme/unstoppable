json.chatroom @chatroom, partial: 'chatrooms/chatroom', as: :chatroom

all_chatrooms_json = {chatrooms: Chatroom.all}
json.merge! all_chatrooms_json

chatrooms_with_number_of_unreads = []
unless  current_user.chatroom_memberships.blank?
    current_user.chatroom_memberships.each do |chatroom_membership|
        chatroom_messages = chatroom_membership.chatroom.chatroom_messages
        count = 0
        chatroom_messages.each do |m|
            if chatroom_membership.last_read_at.nil? || (m.created_at > chatroom_membership.last_read_at)
                count = count + 1
            end
        end
        chatroom_membership_details = {id: chatroom_membership.chatroom.id, name: chatroom_membership.chatroom.name, number_of_unreads: count}
        chatrooms_with_number_of_unreads << chatroom_membership_details
    end
end
all_chatrooms_json = {chatrooms: chatrooms_with_number_of_unreads}
json.merge! all_chatrooms_json



