class ManagementController < ApplicationController

    def get_email_address
        Rails.logger.info("In GET_EMAIL_ADDRESS")
        render 'get_email_address'
    end
    
    def send_username
        @user = User.find_by_email(params[:user][:email])
        Rails.logger.debug("send_userbane @user = #{@user.inspect} params = #{params.inspect}")
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
