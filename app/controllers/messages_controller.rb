class MessagesController < ApplicationController
    before_action :set_conversation

    def create
        receipt = current_user.reply_to_conversation(@conversation, params[:body])
        Rails.logger.debug "In Message Controller conversation = #{@conversation.inspect}"
        Rails.logger.debug "In Message Controller messages = #{@conversation.messages.inspect}"
        Rails.logger.debug "In Message Controller receipt = #{receipt.inspect}"
        Rails.logger.debug "In Message Controller params = #{params.inspect}"
        @recipients = nil
        unless params["recipients"].blank?
            @recipients = params["recipients"]
        end
        Rails.logger.debug "In Message Controller params = #{@recipeints.inspect}"
        redirect_to conversation_path(receipt.conversation, recipients: params["recipients"])
        #redirect_to conversation_path(receipt.conversation)
    end

    private
        def set_conversation
            @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
        end
end