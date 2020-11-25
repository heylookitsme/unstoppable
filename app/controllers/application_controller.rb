class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  respond_to :html, :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_last_seen_at, if: -> {user_signed_in? && (current_user.last_seen_at.nil? ||current_user.last_seen_at < 5.minutes.ago)}

  helper_method :current_user, :get_current_user

  protected

  def update_last_seen_at
    Rails.logger.info "Update last seen at timestamp for user= #{current_user.inspect}"
    current_user.update_attribute(:last_seen_at, Time.current);
  end

  def configure_permitted_parameters
    Rails.logger.debug "In Application Controller configure_permitted_parameters params = #{params.inspect}"
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :terms_of_service])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def current_user
    @current_user ||= User.find_by_id session[:user_id] if session[:user_id]
    User.current = @current_user if User.current.nil?
    #if @current_user
    #  @current_user
    #else
      #OpenStruct.new(name: 'Guest')
      #nil
    #end
    return User.current
  end

  def set_current_user(user)
    User.current = user
  end

  def after_sign_out_path_for(resource_or_scope)
    #request.referrer
    new_user_session_path
  end
end
