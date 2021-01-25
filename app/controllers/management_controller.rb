class ManagementController < ApplicationController
    respond_to :json, :html

    def get_email_address
        flash.delete(:non_existent_user_error)
        Rails.logger.info("In GET_EMAIL_ADDRESS")
        render 'get_email_address'
    end
    
    def send_username
        Rails.logger.debug "In  Management controller, send_username request = #{request.referrer.inspect} request format = #{request.format.json?.inspect}"
        #Rails.logger.info("Insend_username params = #{params.inspect}")
        @user = User.find_by_email(params[:user][:email])
        #Rails.logger.info("Insend_username @user = #{@user.inspect}")
        flash.delete(:non_existent_user_error)
        if @user.blank?
            if params[:user][:email].blank?
                flash[:non_existent_user_error] = "Please enter an email."
            else
                flash[:non_existent_user_error] = "No User exists for this email #{params[:user][:email].inspect} Please re-enter email."
            end
            render 'get_email_address'
            return
        end
        #Rails.logger.debug("send_userbane @user = #{@user.inspect} params = #{params.inspect}")
        if(params[:stype] == "P")
            if request.format.json? 
                #raw, enc = Devise.token_generator.custom_generate(self.class, :reset_password_token)
                #@user.reset_token = SecureRandom.random_number(10000).to_s
                @user.update_attribute(:reset_token, SecureRandom.random_number(10000).to_s )
                UserMailer.forgot_password_json(@user, Settings.base_url + "forgotPassword/").deliver
            else
                @user.send_reset_password_instructions
                render "forward_password"
            end
        else
            if request.format.json? 
                Rails.logger.debug "JSON request, send_username"
                UserMailer.forgot_username(@user, Settings.base_url).deliver
            else
                UserMailer.forgot_username(@user, Settings.server_url).deliver
                flash[:success] = "An email has been sent to your account with your username."
                render "forward_username"
            end
        end
    end

    def get_email_address
        Rails.logger.info("In GET_EMAIL_ADDRESS")
        render 'get_email_address'
    end
end
