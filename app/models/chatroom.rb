class Chatroom < ApplicationRecord
  has_many :chatroom_messages
  has_many :chatroom_memberships
end
