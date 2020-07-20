class AccountSettingsController < ApplicationController
  before_action :authenticate_user!
  respond_to  :json

  def change_username
    Rails.logger.debug "In AccountSettingsController, change_username, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_username, user = #{user.inspect}"
    
    Rails.logger.debug  "In AccountSettingsController, change_username, username = #{params[:username].inspect}"
    user.username = params[:username]
    if user.invalid? && user.errors[:username].any?
      Rails.logger.debug " #{user.invalid?} #{user.errors[:username]}"
      render :json => {status:  "error", code:4000, message: user.errors[:username].to_s}
    else
      if(user.update_attribute(:username, params[:username]))
        Rails.logger.debug  "In AccountSettingsController, change_username, saved user with new username = #{user.inspect}"
        render json: user.to_json, status: 200
      else
        render  json: {status: "error", code:4000, message: user.errors[:username].to_json}
      end
    end
=begin
    
=end    
  end

  def change_email
    Rails.logger.debug "In AccountSettingsController, change_email, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_email, user = #{user.inspect}"
    if params[:email].blank?
      payload = {
          error: "Email absent. Cannot update Email",
          status: 400
          }
      render :json => payload, :status => :bad_request
    end
    
    Rails.logger.debug  "In AccountSettingsController, change_email, email = #{params[:email].inspect}"
    user.email = params[:email]
    if(user.save(:validate => false))
      Rails.logger.debug  "In AccountSettingsController, change_email, saved user with new email = #{user.inspect}"
      render json: user.to_json, status: 200
    else
      Rails.logger.debug  "In AccountSettingsController, change_email, email = NULL"
      payload = {
          error: "Cannot update email",
          status: 400
          }
      render :json => payload, :status => :bad_request
    end
    
  end

  def change_zipcode
  end
end
