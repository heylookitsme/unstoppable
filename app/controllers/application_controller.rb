class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user, :get_current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
    
    User.current = @current_user
    if @current_user
      @current_user
    else
      #OpenStruct.new(name: 'Guest')
      nil
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:user_id] = resource_or_scope.id
    #user_path(resource_or_scope)
    if resource_or_scope.admin?
      rails_admin_path
    else
      profiles_path
    end
    #if resource_or_scope.is_a?(User)
    #  super
   #else
      #Rails.logger.debug("User12345")
      #users_path
    #end
  end
  def after_sign_out_path_for(resource_or_scope)
    #request.referrer
    new_user_session_path
  end
end
