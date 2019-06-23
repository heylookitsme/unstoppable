class ConversationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    #protect_from_forgery with: :null_session
    before_action :authenticate_user!

    def index
        Rails.logger.debug("params = #{params.inspect}")
        #@conversations = current_user.mailbox.conversations #
        @conversations = current_user.mailbox.inbox #
        Rails.logger.debug("Conversations Inbox = #{@conversations.inspect}")
    end
    def show
        # <span class="badge"><%= current_user.mailbox.inbox({:read => false}).count %></span >
        Rails.logger.debug("In show params = #{params.inspect}")
        Rails.logger.debug("In show request = #{request.referer.inspect}")
        @conversation = current_user.mailbox.conversations.find(params[:id])
        @receipts = @conversation.receipts_for current_user
        @receipts.mark_as_read
        #@receipts = mailbox.receipts_for(conversation).not_trash
        #@receipts.mark_as_read

        unless params["recipients"].blank?
            @recipients = params["recipients"]
        end
        @from_tab = ""
        unless params["from_tab"].blank?
            @from_tab = params["from_tab"]
        end
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

    def trash
        Rails.logger.debug("params = #{params.inspect}")
        @conversations = current_user.mailbox.trash
        @recipients = {}
        @conversations.each do |s|
            @recipients[s.id] = s.messages.first.recipients.first.username
        end

    end

=begin
    def trash_multiple
        Rails.logger.debug("Archive conversation for the following: #{params[:conversation_ids].inspect}")
        #params[:conversation_ids].each do |c|
        #    c.move_to_trash(c)
        #end
        respond_to do |format|
          format.html { redirect_to conversations_path }
          #format.json { head :no_content }
        end
    end
=end

    def destroy_multiple
        #Rails.logger.debug("Archive conversation for the following: #{params[:conversation_ids].inspect}")
        Mailboxer::Conversation.destroy(params[:conversation_ids])
        respond_to do |format|
          format.html { redirect_to conversations_path }
          format.json { head :no_content }
        end
    end
 
    def destroy
        Rails.logger.debug("Destroy : #{params[:conversation_ids].inspect}")
        Mailboxer::Conversation.destroy(params[:id])
        respond_to do |format|
          format.html { redirect_to conversations_path }
          #format.json { head :no_content }
        end
    end

end