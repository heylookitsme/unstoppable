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

  def valid_username
    Rails.logger.debug "In AccountSettingsController, valid_username, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, valid_username, user = #{user.inspect}"

    user_with_username = User.find_by_username(params[:username])
    Rails.logger.debug "In AccountSettingsController, valid_username, user = #{user_with_username.inspect}" 
    unless user_with_username.blank?
      Rails.logger.debug "User Exists"
      render :json => {status: 200, code:400, message: "Username already been taken"}
    else
      render json:  {status: 200, message: "Good"}
    end
  end

  def change_email
    Rails.logger.debug "In AccountSettingsController, change_email, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_email, user = #{user.inspect}"
    
    Rails.logger.debug  "In AccountSettingsController, change_email, email = #{params[:email].inspect}"
    user.email = params[:email]
    if user.invalid? && user.errors[:email].any?
      Rails.logger.debug " #{user.invalid?} #{user.errors[:email]}"
      render :json => {status:  "error", code:4000, message: user.errors[:email].to_s}
    else
      if(user.update_attribute(:email, params[:email]))
        Rails.logger.debug  "In AccountSettingsController, change_email, saved user with new email = #{user.inspect}"
        render json: user.to_json, status: 200
      else
        render  json: {status: "error", code:4000, message: user.errors[:email].to_json}
      end
    end
    
  end

  def change_zipcode
  end
  def change_dob
    Rails.logger.debug "In AccountSettingsController, change_dob, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_dob, user = #{user.inspect}"
    #  "dob(1i)", "dob(2i)","dob(3i)"
    profile = user.profile
    new_dob = Date.new(params['dob(1i)'].to_i,params['dob(2i)'].to_i,params['dob(3i)'].to_i)
    profile.dob = new_dob
    profile.save!
    # The DOB has a validation for a minimum age of 18,  and if that fails
    if profile.invalid? && profile.errors[:dob].any?
      Rails.logger.debug " #{profile.invalid?} #{profile.errors[:email]}"
      render :json => {status:  "error", message: profile.errors[:dob].to_s}
    else
      if(profile.update_attribute(:dob, new_dob))
        profile.age = ((Time.zone.now - profile.dob.to_time) / 1.year.seconds).floor
        user.dob = profile.dob
        Rails.logger.debug  "In AccountSettingsController, change_dob, saved user with new dob = #{user.inspect}"
        render json: user.to_json, status: 200
      else
        render  json: {status: "error", message:  profile.errors[:dob].to_json}
      end
    end
  end
end
