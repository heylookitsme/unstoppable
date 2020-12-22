json.chatroom @chatroom, partial: 'chatrooms/chatroom', as: :chatroom

all_chatrooms_json = {chatrooms: Chatroom.all}
json.merge! all_chatrooms_json

