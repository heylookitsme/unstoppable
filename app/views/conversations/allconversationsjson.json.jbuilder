
json.conversations @conversations do |conversation|
  	json.extract! conversation, :id #, :subject, :created_at, :updated_at
  participants = conversation.participants
	participant = nil
	participants.each do |p|
		if p.id != current_user.id
	    participant = p
			break;
		end
	end
	unless participant.blank?
		receipts = conversation.receipts_for current_user
		senders = []
		receivers = []
		messages_array = []
		first_message_body = receipts.first.message.body
		if receipts.first.mailbox_type != "inbox"
			receipts = conversation.receipts_for participant
		end

		receipts.each do |receipt|
			message = receipt.message
			if receipt.message.sender_id == current_user.id
				messages_array << {to: participant.username, from: current_user.username, content: message.body, updated_at: message.updated_at}
			else
				messages_array << {to: current_user.username, from: participant.username, content: message.body, updated_at: message.updated_at}
			end
		end
		messages = {messages: messages_array}
		json.merge! messages

		recent = {recent: { subject: conversation.subject, content:  receipts.last.message.body, timestamp: conversation.updated_at }}
		json.merge!  recent
		name = {name: participant.name}
		json.merge!  name

		participant_id = {participant_id: participant.id}
		json.merge!  participant_id

		if participant.profile.avatar.attached?
			avatar = {photo: rails_blob_path(participant.profile.avatar)}
			#avatar = {photo: ""}
			json.merge! avatar
		else
			avatar = {photo: ""}
			json.merge! avatar
		end
	end
end ## This is the end of the conversations loop

unless @participant.blank?
	participantjson = {participant_name: @participant.username}
	json.merge!  participantjson
	if @participant.profile.avatar.attached?
		participantimagejson = {participant_photo: rails_blob_path(@participant.profile.avatar)}
		json.merge!  participantimagejson
	end
else
	participantjson = {participant_name: ""}
	json.merge!  participantjson
	participantimagejson = {participant_photo: ""}
	json.merge!  participantimagejson
end