# frozen_string_literal: true


class Users::RegistrationsController < Devise::RegistrationsController
 #module Users
  #class RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :test_validation, only: [:create]
  skip_before_action :verify_authenticity_token
  #layout "sidebar"
  #layout false
  
  # TODO - currently commenting this out as it giving issues with Reactjs front end. TODO will uncomment late
  #prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  respond_to :json, :html

  def sign_up_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :zipcode, "dob(1i)", "dob(2i)","dob(3i)", :remember_me, :referred_by, :terms_of_service, :phone_number)
 end

 def create
  Rails.logger.debug "In  Registration controller, create"
  build_resource(sign_up_params)
  resource.save
  Rails.logger.debug "In  Registration controller,RESOURCE = #{resource.inspect}"
  yield resource if block_given?
  if resource.persisted?
    if resource.active_for_authentication?
      Rails.logger.debug "In  Registration controller,active_for_authentication, resource= #{resource.inspect}"
      #set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      #respond_with resource, location: after_sign_up_path_for(resource)
    else
      #set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
      Rails.logger.debug "In  Registration controller, NOT ACTIVE resource= #{resource.inspect}"
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end
  else
    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
  end
  Rails.logger.debug "In  Registration controller, create request = #{request.referrer.inspect} request format = #{request.format.json?.inspect}"

  
    # Return success to React server
    #return  welcome_returnsignin_path
    Rails.logger.debug "In  Registration controller,current_user = #{current_user.inspect}"
    Rails.logger.debug "In  Registration controller,current_user = #{resource.inspect}"
    #redirect_to appjson_newuser_user_path(resource, id: resource.id, format: :json) and return if request.format.json? && !resource.id.blank?
    redirect_to welcome_appjson_newuser_path(:id => resource.id) and return if request.format.json? && !resource.id.blank?
    errors_list = resource.errors.full_messages
    Rails.logger.debug "errors = #{errors_list.inspect}"
    #redirect_to welcome_appjson_newuser_path(:error_list => "abc") and return if request.format.json? && resource.id.blank?
    #Rails.logger.debug "In  Registration controller,errors saveing resource = #{resource.errors.inspect}"
    ##errors_list = resource.errors.full_messages
    Rails.logger.debug "errors = #{resource.errors.full_messages.inspect}"
    #render  json: {status: "error", code:4000, messages: errors_list.to_json} and return if request.format.json? && resource.id.blank?
    
    # On the Rails server, this takes you to the "About Me" page, wizard path
    profile_build_path(:about_me, :profile_id => resource.profile.id) if !request.format.json?
end

 protected

 def after_sign_up_path_for(resource)
  Rails.logger.debug "In after_sign_up_path_for resource#{resource.inspect}"
  #UserMailer.with(user: resource).welcome_email.deliver_later
  #UserMailer.registration_confirmation(resource).deliver
  #flash[:success] = "Please confirm your email address to continue"
  #redirect_to root_url
  # Removing email confirmation from second step and move to the end step
  # email_confirmation_user_path(resource, :user_id => resource.id)
  Rails.logger.debug "In after_sign_up_path_for request = #{request.referrer.inspect} request format = #{request.format.json?.inspect}"
  if request.format.json?
    # Return success to React server
    #return  welcome_returnsignin_path
    redirect_to appjson_newuser_user_path(:id => resource.id) and return
  else
    # On the Rails server, this takes you to the "About Me" page
    profile_build_path(:about_me, :profile_id => resource.profile.id)
  end
  #destroy_user_session_path
 end

  # GET /resource/sign_up
  # def new
  #   super
  # 
  
  

  # POST /resource
=begin
   def create
     super
     Rails.logger.debug "In  Registration controller, create request = #{request.referrer.inspect} request format = #{request.format.json?.inspect}"
     if request.format.json?
      # Return success to React server
      #return  welcome_returnsignin_path
      Rails.logger.debug "In  Registration controller, create request = #{request.referrer.inspect} request format = #{request.format.json?.inspect}"
      render appjson_newuser_user_path(:id => resource.id) and return
    else
      # On the Rails server, this takes you to the "About Me" page
      profile_build_path(:about_me, :profile_id => resource.profile.id)
    end
   end
=end
def test_validation
  Rails.logger.debug "In  Registration controller, test, params = #{params.inspect}"
  user = User.find_by_email(params[:user][:email])
  if !user.blank?
    Rails.logger.debug "In  Registration controller, test,user with email  #{params[:user][:email].inspect} already exists"
  end
  render  json: {status: "error", code:4000, messages: "Email has already been taken"} and return if !user.blank?
  user = User.find_by_username(params[:user][:username])
  if !user.blank?
    Rails.logger.debug "In  Registration controller, test,user with username #{params[:user][:username].inspect} already exists"
  end
  render  json: {status: "error", code:4000, messages: "[Username has already been taken]"} and return if !user.blank?
end

  private
    def check_captcha
      if !verify_recaptcha
        flash.delete :recaptcha_error
        params = sign_up_params
        build_resource(params)
        resource.valid?
        #resource.errors.add(:base, "There was an error with the recaptcha code below. Please re-enter the code.")
        flash.delete(:terms_of_service_error)
        if params["g-recaptcha-response"].blank?
          flash[:recaptcha_error] = "Please select reCAPTCHA box to proceed"
        end
        if params["terms_of_service"] == "0"
          flash[:terms_of_service_error] = "Please agree to the Terms of Use"
        end
        clean_up_passwords(resource)
        respond_with_navigational(resource) { render :new }
      else
        flash.delete(:recaptcha_error)
        flash.delete(:terms_of_service_error)
        #super
      end
    end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  #def update
  #  super
  #end

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
  def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:dob, :username, :zipcode])
  end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:dob, :username, :zipcode])
   end

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
