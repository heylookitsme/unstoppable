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
    Rails.logger.debug "SIGN IN"
    Rails.logger.debug "request = #{request.referrer.inspect}"
   
    self.resource = warden.authenticate!(auth_options)
    #set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    # TODO move URL to config file. Also change logic of line below.
    if request.referrer.starts_with?("http://localhost:3000/login")
      render :json=> {:success=>true,  :username=>resource.username, :email=>resource.email}
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
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
