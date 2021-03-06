# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_signed_out_user
  respond_to :json, :html
  #layout false
  #layout "sidebar"

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # POST /resource/sign_in
  def create

    Rails.logger.info "Session Controller, create SIGN IN"
    Rails.logger.info "Session Controller, create request = #{request.referrer.inspect}"
   
    self.resource = warden.authenticate!(auth_options)
    #set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    User.current = resource
    current_user = resource
    session[:user_id] = resource.id
    Rails.logger.debug "Session Controller, create user = #{resource.inspect}"
    # TODO move URL to config file. Also change logic of line below.
    #respond_with resource, :location => after_sign_in_path_for(resource) do |format|
    #  format.json {render :json => resource } # this code will get executed for json request
    #end

    Rails.logger.debug("request = #{request.format.inspect}")
    if request.format.json? #request.referrer.starts_with?("http://localhost:3000/login")
      Rails.logger.debug "Session Controller,redirecting to users/appjson current_user = #{current_user.inspect}"
      #redirect_to welcome_appjson_path(:format => :json)
      render "users/appjson", :id => current_user.id
      #respond_with resource, location: welcome_appjson_path(:format => :json)
    else
      if current_user.blank?
        redirect_to new_user_session_path
      else
        if current_user.profile.step_status == Profile::STEP_CONFIRMED_EMAIL
          redirect_to profiles_path
        else
          case current_user.profile.step_status
            when Profile::STEP_EMAIL_CONFIRMATION_SENT
              redirect_to remind_confirmation_user_path(current_user)
            when Profile::STEP_CANCER_HISTORY
              redirect_to attachment_photo_path(:profile_id => current_user.profile.id)
            when Profile::STEP_ABOUT_ME
              redirect_to profile_build_path(:cancer_history, :profile_id => current_user.profile.id)
            when Profile::STEP_BASIC_INFO
              redirect_to profile_build_path(:about_me, :profile_id => current_user.profile.id)
          end
        end
      end
    end
=begin   
    if request.referrer.starts_with?("http://localhost:3000/login")
      redirect_to welcome_appjson_path(:format => :json)
    else
      unless current_user.blank?
        respond_with resource, location: welcome_index_path
      else
        Rails.logger.debug "SHOULD GO TO NEW USER SESSION"
      end
    end
=end
  end

  # DELETE /resource/sign_out
   def destroy
  #   super
    sign_out(resource)
    render :json=> {:success=>true}
   end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
   end
end
