class ConversationsController < ApplicationController

    def index
        Rails.logger.debug("params = #{params.inspect}")
        @conversations = current_user.mailbox.conversations #
        Rails.logger.debug("Conversations = #{@conversations.inspect}")
    end
    def show
        # <span class="badge"><%= current_user.mailbox.inbox({:read => false}).count %></span >
        @conversation = current_user.mailbox.conversations.find(params[:id])
        @receipts = @conversation.receipts_for current_user
    end

    def new
        # <%= f.hidden_field :user_id, :value =>  @message_to_id %>
        Rails.logger.info "In Conversaation Controller new params= #{params.inspect}"
        @recipients = User.all - [current_user]
        @message_to_id = params[:user_id]
        Rails.logger.info "In Conversaation Controller  @message_to_id= #{@message_to_id.inspect}"
    end

    def create
        Rails.logger.info "In Conversaation Controller create params= #{params.inspect}"
        recipient= User.find(params[:user_id])
        Rails.logger.info "In Conversaation Controller create recipient= #{recipient.inspect}"
        Rails.logger.info "In Conversaation Controller current_user= #{current_user.inspect}"
        receipt = current_user.send_message(recipient, params[:body], params[:subject])
        Rails.logger.info "In Conversaation Controller receipt= #{receipt.inspect}"
        redirect_to conversation_path(receipt.conversation)
    end

    def sentbox
        Rails.logger.debug("params = #{params.inspect}")
        @conversations = current_user.mailbox.sentbox
        @recipients = {}
        @conversations.each do |s|
            @recipients[s.id] = s.messages.first.recipients.first.username
        end

    end

    def destroy_multiple
        Mailboxer::Conversation.destroy(params[:conversation_ids])
        respond_to do |format|
          format.html { redirect_to conversations_path }
          #format.json { head :no_content }
        end
    end

 
    def destroy
        Mailboxer::Conversation.destroy(params[:id])
        respond_to do |format|
          format.html { redirect_to conversations_path }
          #format.json { head :no_content }
        end
    end

end