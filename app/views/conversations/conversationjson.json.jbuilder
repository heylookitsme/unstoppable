json.extract! @conversation, :id #, :subject, :created_at, :updated_at

receipts = @conversation.receipts_for current_user
senders = []
receivers = []
messages_array = []
first_message_body = receipts.first.message.body
if receipts.first.mailbox_type != "inbox"
  receipts = @conversation.receipts_for @participant
end

receipts.each do |receipt|
	message = receipt.message
	if receipt.message.sender_id == current_user.id
		messages_array << {to: @participant.username, from: current_user.username, content: message.body}
	else
		messages_array << {to: current_user.username, from: @participant.username, content: message.body}
	end
end
messages = {messages: messages_array}
json.merge! messages

recent = {recent: { subject: @conversation.subject, content:  receipts.last.message.body, timestamp: @conversation.updated_at }}
json.merge!  recent


participantjson = {name: @participant.username}
json.merge!  participantjson
if @participant.profile.avatar.attached?
	participantimagejson = {image: rails_blob_path(@participant.profile.avatar)}
	json.merge!  participantimagejson
end
