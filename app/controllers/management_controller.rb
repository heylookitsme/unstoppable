class ManagementController < ApplicationController
    
    def get_email_address
        flash.delete(:non_existent_user_error)
        Rails.logger.info("In GET_EMAIL_ADDRESS")
        render 'get_email_address'
    end
    
    def send_username
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
           @user.send_reset_password_instructions
           render "forward_password"
        else
            UserMailer.forgot_username(@user).deliver
            flash[:success] = "An email has been sent to your account with your username."
            render "forward_username"
        end
    end

    def get_email_address
        Rails.logger.info("In GET_EMAIL_ADDRESS")
        render 'get_email_address'
    end
end
