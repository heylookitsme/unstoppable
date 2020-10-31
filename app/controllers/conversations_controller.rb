class ConversationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    #protect_from_forgery with: :null_session
    before_action :authenticate_user!
    respond_to :json, :html

    def index
        Rails.logger.debug("params = #{params.inspect}")
        #@conversations = current_user.mailbox.conversations #
        @conversations = current_user.mailbox.inbox #
        Rails.logger.debug("Conversations Inbox = #{@conversations.inspect}")
        @recipients = {}
        @conversations.each do |s|
            s.messages.last.recipients.each do |r|
                unless r.id == current_user.id
                    @recipients[s.id] = r
                end
            end
            Rails.logger.debug("Conversations s = #{s.id} @recipeints = #{@recipients[s.id].inspect}")
        end
    end
    def show
        # <span class="badge"><%= current_user.mailbox.inbox({:read => false}).count %></span >
        Rails.logger.debug("In show params = #{params.inspect}")
        Rails.logger.debug("In show request = #{request.referer.inspect}")
        @conversation = current_user.mailbox.conversations.find(params[:id])
        @receipts = @conversation.receipts_for current_user
        @receipts.mark_as_read

        @recipient_users = []
        # @recipients is the list of ids
        unless params["recipients"].blank?
            @recipients = params["recipients"]
            # Need to change to loop. Currently @recipients is single element, not an array of users
            @recipient_users << User.find(@recipients.to_i)
            Rails.logger.debug("In show  @recipient_users = #{@recipient_users.inspect}")
        end

        @from_tab = ""
        unless params["from_tab"].blank?
            @from_tab = params["from_tab"]
        end
    end

    def new
        # <%= f.hidden_field :user_id, :value =>  @message_to_id %>
        Rails.logger.info "In Conversation Controller new params= #{params.inspect}"
        @recipients = User.all - [current_user]
        @message_to_id = params[:user_id]
        unless @message_to_id.blank?
            @receiver = User.find(@message_to_id)
        end
        Rails.logger.info "In Conversation Controller  @message_to_id= #{@message_to_id.inspect}"
    end

    def create
        #Rails.logger.info "In Conversation Controller create params= #{params.inspect}"
        recipient= User.find(params[:user_id])
        Rails.logger.info "In Conversation Controller create recipient= #{recipient.inspect}"
        Rails.logger.info "In Conversation Controller current_user= #{current_user.inspect}"
        receipt = current_user.send_message(recipient, params[:body], params[:subject])
        Rails.logger.info "In Conversation Controller receipt= #{receipt.inspect}"
        ## An email is sent to the recipient
        #UserMailer.inform_message_recipient(current_user, recipient).deliver
        ##  An email is sent to the recipient
        #redirect_to conversation_path(receipt.conversation)

        respond_to do |format|
            format.html { redirect_to conversation_path(receipt.conversation) }
            format.json { redirect_to conversationjson_conversation_path(receipt.conversation, user_id: params[:user_id])}
        end
    end

    def sentbox
        Rails.logger.debug("params = #{params.inspect}")
        @conversations = current_user.mailbox.sentbox
        @recipients = {}
        @conversations.each do |s|
            @recipients[s.id] = s.messages.last.recipients.first
        end

    end

    def trash
        Rails.logger.debug("params = #{params.inspect}")
        @conversations = current_user.mailbox.trash
        @recipients = {}
        @conversations.each do |s|
            @recipients[s.id] = s.messages.last.recipients.first
        end

    end


    def trash_multiple
        Rails.logger.debug("Archive conversation for the followingg: #{params.inspect}")
        multiple_conversation_delete(params)
        respond_to do |format|
            format.html { redirect_to conversations_trash_path }
            format.json { head :no_content }
        end
    end

    def destroy_multiple
        Rails.logger.debug("Archive conversation for the following: #{params.inspect}")
        multiple_conversation_delete(params)
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

    def conversationjson
        Rails.logger.debug("In Conversation controller, conversationjson action. params = #{params.inspect}")
        @conversation = current_user.mailbox.conversations.find(params[:id])
        unless params[:user_id].blank?
            @participant = User.find(params[:user_id])
        else
            @conversation.participants.each do |participant|
                if participant != current_user
                    @participant = participant
                end
            end
        end

        #@participant = User.find(params[:user_id])
        respond_to do |format|
            format.json
        end
    end

    def conversationsjson
        Rails.logger.debug("In Conversation controller, conversationjson action. params = #{params.inspect}")
        if params[:user_id].blank?
            render :json => { :errors => {error: "You need to specify user id"} }
        end
        Rails.logger.debug("In Conversation controller, conversationjson action. current_user = #{current_user.inspect}")
        #@user = User.find(params[:user][:id])
        #Rails.logger.debug("In Conversation controller, conversationjson action. @user = #{@user.inspect}")
        @participant = User.find(params[:user_id])
        Rails.logger.debug("In Conversation controller, conversationjson action. @participant = #{@participant.inspect}")
        conversations = current_user.mailbox.inbox #
        Rails.logger.debug("Conversations Inbox = #{@conversations.inspect}")
        @conversations = []
        conversations.each do |c|
            c.participants.each do |p|
                if p.id == @participant.id
                    @conversations << c
                    break
                end
            end
        end
        respond_to do |format|
            format.json
        end
    end

    def allconversationsjson
        Rails.logger.debug("In Conversation controller, allconversationsjson action. current_user = #{current_user.inspect}")

        @participant = User.find(params[:participant_id]) unless params[:participant_id].blank?
        Rails.logger.debug("In Conversation controller, conversationjson action. @participant = #{@participant.inspect}")

        @conversations = current_user.mailbox.inbox #
        Rails.logger.debug("Conversations Inbox = #{@conversations.inspect}")
        if @conversations.blank?
            @conversations = current_user.mailbox.sentbox
        end
        #@conversations.each do |c|
        #    Rails.logger.debug("In Conversation controller, allconversationsjson action. conversation loop participants = #{c.participants.inspect}")
        #end
        Rails.logger.debug("In Conversation controller, allconversationsjson action. @participant = #{@participant.inspect}")
        respond_to do |format|
            format.json
        end
    end


    private

    def multiple_conversation_delete(params)
        unless params[:commit].blank?
            if params[:commit] == "Delete"
                Mailboxer::Conversation.destroy(params[:conversation_ids])
            elsif params[:commit] == "Archive"
                Rails.logger.debug("conversation_ids = : #{params[:conversation_ids].inspect}")
                params[:conversation_ids].each do |c_id|
                    current_user.mailbox.conversations.each do |conversation|
                        if conversation.id  == c_id.to_i
                                Rails.logger.debug("Matched Conversation id = #{c_id}.inspect being moved to trash")
                                conversation.move_to_trash(current_user)
                            break
                        end
                    end
                end
            end
        end
    end
end
