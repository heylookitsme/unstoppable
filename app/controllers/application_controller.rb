class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
    Rails.logger.debug("YAHOO")
    Rails.logger.debug("#{@current_user.inspect}")
    Rails.logger.debug("#{session[:user_id].inspect}")
    if @current_user
      @current_user
    else
      #OpenStruct.new(name: 'Guest')
      nil
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:user_id] = resource_or_scope.id
    user_path(resource_or_scope)
    #if resource_or_scope.is_a?(User)
    #  super
   #else
      #Rails.logger.debug("User12345")
      #users_path
    #end
  end
end
