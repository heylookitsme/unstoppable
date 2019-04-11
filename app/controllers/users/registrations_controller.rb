# frozen_string_literal: true


class Users::RegistrationsController < Devise::RegistrationsController
 #module Users
  #class RegistrationsController < Devise::RegistrationsController

  #before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  layout "sidebar"
  #layout false
  
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  def sign_up_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :zipcode, "dob(1i)", "dob(2i)","dob(3i)", :remember_me)
 end
 protected

 def after_sign_up_path_for(resource)
  Rails.logger.debug "#{resource.inspect}"
  #UserMailer.with(user: resource).welcome_email.deliver_later
  UserMailer.registration_confirmation(resource).deliver
  flash[:success] = "Please confirm your email address to continue"
  #redirect_to root_url
  email_confirmation_user_path(resource, :user_id => resource.id)
  #destroy_user_session_path
 end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end
  
  private
    def check_captcha
      if !verify_recaptcha secret_key: '6Lfan4EUAAAAALHBMh_Rl6SOoDosdhrIRi2vRD3M'
        flash.delete :recaptcha_error
        build_resource(sign_up_params)
        resource.valid?
        resource.errors.add(:base, "There was an error with the recaptcha code below. Please re-enter the code.")
        clean_up_passwords(resource)
        respond_with_navigational(resource) { render :new }
      else
        flash.delete :recaptcha_error
        #super
      end
     
    end
    

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
   #def configure_sign_up_params
   #  devise_parameter_sanitizer.permit(:sign_up, keys: [:dob])
   #end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
##end
end
