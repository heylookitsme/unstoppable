conversation = current_user.mailbox.inbox.first
json.extract! conversation, :id #, :subject, :created_at, :updated_at

receipts = conversation.receipts_for current_user
senders = []
messages_array = []
first_message_body = receipts.first.message.body
receipts.each do |receipt|
  message = receipt.message
	senders << message.sender_id if message.sender_id != current_user.id
end
sender_id = senders.first
sender = User.find(sender_id)

receipts.each do |receipt|
  message = receipt.message
	if receipt.mailbox_type == "inbox"
		messages_array << {to: current_user.username, from: sender.username, content: message.body}
	else
		messages_array << {to: sender.username, from: current_user.username, content: message.body}
	end
end
messages = {messages: messages_array}
json.merge! messages

recent = {recent: { subject: conversation.subject, content:  receipts.last.message.body, timestamp: conversation.updated_at }}
json.merge!  recent

unless senders.empty?
	senderjson = {name: sender.username}
	json.merge!  senderjson
	if sender.profile.avatar.attached?
		senderimagejson = {image: rails_blob_path(sender.profile.avatar)}
		json.merge!  senderimagejson
	end
end



