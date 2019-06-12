class ConversationsController < ApplicationController
    def index
        @conversations = current_user.mailbox.conversations #
        Rails.logger.debug("Conversations = #{@conversations.inspect}")
        # @inbox = current_user.mailbox.inbox
        # @sentbox = current_user.mailbox.sentbox
        # @trash = current_user.mailbox.trash
    end
    def show
        @conversation = current_user.mailbox.conversations.find(params[:id])
    end

    def new
        @recipients = User.all - [current_user]
    end

    def create
        recipient= User.find(params[:user_id])
        receipt = current_user.send_message(recipient, params[:body], params[:subject])
        redirect_to conversation_path(receipt.conversation)
    end

    def destroy_multiple
        Mailboxer::Conversation.destroy(params[:conversation_ids])
        respond_to do |format|
          format.html { redirect_to conversations_path }
          #format.json { head :no_content }
        end
      end
end