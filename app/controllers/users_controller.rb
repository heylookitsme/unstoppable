class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :except => [:confirm_email, :confirm_email_json, :terms, :appjson_newuser]
  #layout "sidebar"
  respond_to :json, :html

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    respond_with(@user)
  end

  def edit
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    Rails.logger.info("in edit user= #{@user.inspect}")
  end


  def update
    Rails.logger.debug "User Controller: Update #{params.inspect}"
=begin
    if @profile.update(profile_params)
      flash[:notices] = ["Your profile was successfully updated"]
      @view_profile = @profile
      respond_to do |format|
        #format.js { render partial: 'search-results'}
        format.html {redirect_to profile_path}
        format.json { render :json => @profile }
      end
    else
      flash[:notices] = ["Your profile could not be updated"]
      render 'edit'
    end
=end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.require(:user).permit(:username, :email, :admin, email_confirmed, confirm_token, reset_password_token, :password, :password_confirmation, :current_password)
    #params.require(:user).permit(:password, :password_confirmation, :current_password)
    params.require(:user).permit(:password, :password_confirmation, :current_password, :zipcode, "dob(1i)", "dob(2i)","dob(3i)", :email, :username)
  end

  def confirm_email
    #Rails.logger.info "In User controller, confirm_email"
    Rails.logger.info "In  confirm_email = #{params.inspect}"
    user = User.find_by_confirm_token(params[:id])
    Rails.logger.info "In confirm_email user =#{user.inspect}"
    if user
      user.email_activate
      #flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
      #Please sign in to continue."
      # STEP_CONFIRMED_EMAIL = "Confirmed Email"
      user.profile.step_status = Profile::STEP_CONFIRMED_EMAIL
      user.profile.save!(:validate => false)
      # Removing email confirmation from second step and move to the end step
      # redirect_to profile_build_path(:about_me, :profile_id => user.profile.id)
      # Send email to all the Admins, that a new User has confirmed
      UserMailer.inform_admins_new_registration(user).deliver
      #redirect_to new_session_path(user)
      remote_url = Settings.base_url +  "welcome"
      redirect_to remote_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to users_sign_out_path
    end
  end

  def confirm_email_json
    #Rails.logger.info "In User controller, confirm_email"
    Rails.logger.info "In  confirm_email = #{params.inspect}"
    user = User.find_by_confirm_token(params[:id])
    Rails.logger.info "In confirm_email user =#{user.inspect}"
    render json:  {status: error, message: "User does not exist"} and return if user.blank?
    # User exists
    user.email_activate
    user.profile.step_status = Profile::STEP_CONFIRMED_EMAIL
    user.profile.save!(:validate => false)
    UserMailer.inform_admins_new_registration(user).deliver
    Rails.logger.debug "#{Settings.base_url.inspect}"
    redirect_to Settings.base_url
    #render json:  {status: 200, message: "OK"}
  end

  def email_confirmation
     #Rails.logger.info "In User controller, email_confirmation"
    #Rails.logger.info "In  email_confirmation = #{params.inspect}"
    @user = User.find_by_id(params[:id])
    @user.profile.step_status = Profile::STEP_EMAIL_CONFIRMATION_SENT
    @user.profile.save
    UserMailer.registration_confirmation(@user).deliver
    #reset_session
  end

  def email_confirmation_sent
    #Rails.logger.info "In User controller, email_confirmation_sent"
    #Rails.logger.info "In  email_confirmation_sent = #{params.inspect}"
    @user = User.find_by_id(params[:user_id])
    reset_session
  end

  def remind_confirmation
    #Rails.logger.info "In User controller, remind_confirmation"
    #Rails.logger.info "In  remind_confirmation = #{params.inspect}"
    @user = User.find_by_id(params[:id])
  end

  def resend_confirmation
    Rails.logger.info "In User controller, resend_confirmation"
    Rails.logger.info "In  resend_confirmation = #{params.inspect}"
    @user = User.find_by_id(params[:id])
    UserMailer.registration_confirmation(@user).deliver
    flash[:success] = "Please confirm your email address to continue"
    redirect_to email_confirmation_sent_user_path(@user, :user_id => @user.id)
    #reset_session
  end

  def resend_confirmation_json
    Rails.logger.info "In User controller, resend_confirmation_json"
    Rails.logger.info "In  resend_confirmation_json = #{params.inspect}"
    @user = User.find_by_id(params[:id])
    Rails.logger.info "In resend_confirmation_json user =#{@user.inspect}"
    UserMailer.registration_confirmation(@user).deliver
    redirect_to Settings.base_url
  end

  def edit_password
    @user = current_user
    render "edit_password"
  end

  def update_password
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to root_path
    else
      render "edit_password"
    end
  end

  def terms
    Rails.logger.debug "UserCOntroller: terms"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_account_settings
    @user = current_user
    @user.dob = @user.profile.dob
    @user.zipcode = @user.profile.zipcode
    
  end

  # This method is currently being used by the Rails app. TODO: Needs to be removed as Accountsettings controller has been created.
  def save_account_settings
    @user = current_user
    @user.referred_by = @user.profile.referred_by
    @user.dob = @user.profile.dob
    @user.zipcode = @user.profile.zipcode
    profile = Profile.find(@user.profile.id)
    profile.zipcode = user_params[:zipcode]
    profile.save!
    Rails.logger.info "In save_account_settings params =#{user_params.inspect}"
    if @user.save
      Rails.logger.info "#user =#{@user.inspect}"
      flash[:notices] = ["Your Account settings were successfully updated"]
      respond_to do |format|
        #format.js { render partial: 'search-results'}
        format.html { redirect_to user_path(@user)}
        format.json { render :json => @user }
      end
    else
      flash[:notices] = ["Your account settings could not be updated"]
      render "edit_account_settings"
    end
  end

  # Return JSON built by appjson.json.jbuilder to the Reactjs app
  def appjson
    Rails.logger.debug("In User controller, appjson action. Current userr = #{current_user.inspect}")
  end
  
end
