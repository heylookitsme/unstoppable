class AccountSettingsController < ApplicationController
  before_action :authenticate_user!
  respond_to  :json

  def change_username
    Rails.logger.debug "In AccountSettingsController, change_username, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_username for user = #{user.inspect}"
    
    Rails.logger.debug  "In AccountSettingsController, change_username, username = #{params[:username].inspect}"
    user.username = params[:username]
    # Check validation without saving
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
  end

  def valid_username
    Rails.logger.debug "In AccountSettingsController, valid_username, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, valid_username for user = #{user.inspect}"
    render json:  {status: 200, message: "Good"} and return if (user.username == params[:username])
    user_with_username = User.find_by_username(params[:username])
    Rails.logger.debug "In AccountSettingsController, valid_username  existing user = #{user_with_username.inspect}"   
    render :json => {status: 200, code:400, message: "Username already been taken"} and return unless user_with_username.blank?
    render json:  {status: 200, message: "Good"} and return if user_with_username.blank?
  end

  def valid_email
    Rails.logger.debug "In AccountSettingsController, valid_email, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, valid_email for  user = #{user.inspect}"
    render json:  {status: 200, message: "Good"} and return if (user.email == params[:email])
    user_with_email = User.find_by_email(params[:email])
    Rails.logger.debug "In AccountSettingsController, valid_email, user = #{user_with_email.inspect}" 
    render :json => {status: 200, code:400, message: "Email already been taken"} and return  unless user_with_email.blank?
    user.email = params[:email]
    render :json => {status: "error", code:400, message: user.errors[:email].to_s} and return if user.invalid? && user.errors[:email].any?
    render json:  {status: 200, message: "Good"} and return 
  end

  def valid_phone
    Rails.logger.debug "In AccountSettingsController, valid_phone, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, valid_phone for user = #{user.inspect}"
    render json:  {status: 200, message: "Good"} and return if (user.phone.phone_number == params[:phone])
    user_with_phone = User.find_by_username(params[:phone])
    Rails.logger.debug "In AccountSettingsController, valid_phone, existing user = #{user_with_email.inspect}" 
    render :json => {status: 200, code:400, message: "Phone number already been taken"} and return if user_with_phone.blank?
    user.phone = params[:phone]
    Rails.logger.debug " valid_phone: #{user.invalid?} #{user.errors[:phone]}"
    render :json => {status: "error", code:400, message: user.errors[:phone].to_s} and return if user.invalid? && user.errors[:phone].any?
    render json:  {status: 200, message: "Good"} and return 
  end

  def change_email
    Rails.logger.debug "In AccountSettingsController, change_email, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_email for user = #{user.inspect}"
    
    Rails.logger.debug  "In AccountSettingsController, change_email, email = #{params[:email].inspect}"
    user.email = params[:email]
     # Check validation without saving
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
    Rails.logger.debug "In AccountSettingsController, change_zipcode, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_zipcode for user = #{user.inspect}"
    profile = user.profile
    new_zipcode = params[:zipcode]
    profile.zipcode = new_zipcode
    # Check validation without saving
    # The Zipcode has to be a valid USA zipcode or else it fails
    if profile.invalid? && profile.errors[:zipcode].any?
      Rails.logger.debug " #{profile.invalid?} #{profile.errors[:zipcode]}"
      render :json => {status:  "error", message: profile.errors[:zipcode].to_s}
    else
      if(profile.update_attribute(:zipcode, new_zipcode))
        Rails.logger.debug  "In AccountSettingsController, change_zipcode, saved user with new zipcode = #{user.inspect}"
        user.zipcode = profile.zipcode
        render json: user.to_json, status: 200
      else
        render  json: {status: "error", message:  profile.errors[:zipcode].to_json}
      end
    end
  end

  def change_dob
    Rails.logger.debug "In AccountSettingsController, change_dob, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_dob for user = #{user.inspect}"
    #  "dob(1i)", "dob(2i)","dob(3i)"
    profile = user.profile
    new_dob = Date.new(params['dob(1i)'].to_i,params['dob(2i)'].to_i,params['dob(3i)'].to_i)
    profile.dob = new_dob
     # Check validation without saving
    # The DOB has a validation for a minimum age of 18,  and if that fails
    if profile.invalid? && profile.errors[:dob].any?
      Rails.logger.debug " #{profile.invalid?} #{profile.errors[:dob]}"
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

 def change_phone
    Rails.logger.debug "In AccountSettingsController, change_phone, params = #{params.inspect}"
    user = User.find(params[:id])
    Rails.logger.debug "In AccountSettingsController, change_phone for user = #{user.inspect}"
    
    user.phone_number = params[:phone]
    if user.invalid? && user.errors[:phone_number].any?
      Rails.logger.debug " #{user.invalid?} #{user.errors[:phone_number]}"
      render :json => {status:  "error", message: user.errors[:phone_number].to_s}
    else
      if user.phone.blank?
        user.phone = Phone.new
      end
      if(user.phone.update_attribute(:phone_number, params[:phone]))
        Rails.logger.debug  "In AccountSettingsController, change_phone, saved user with new phone = #{user.inspect}"
        render json: user.to_json, status: 200
      else
        render  json: {status: "error", message:  user.errors[:phone_number].to_json}
      end
    end
 end

 def user_params
  params.require(:user).permit(:password, :password_confirmation, :current_password)
end

 def update_password
  Rails.logger.debug "In AccountSettingsController, update_password, params = #{params.inspect}"
  user = User.find(params[:id])

  if user.update_with_password(user_params)
    # Sign in the user by passing validation in case their password changed
    bypass_sign_in(user)
    render json: user.to_json, status: 200
  else
    render json: {status: "error", message:  user.errors.all.to_json}
  end
end

end
