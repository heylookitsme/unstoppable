class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :except => [:show, :confirm_email, :terms]
  #layout "sidebar"

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
  end

  def edit
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    Rails.logger.info("in edit user= #{@user.inspect}")
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    #params.require(:user).permit(:username, :email, :admin, email_confirmed, confirm_token, reset_password_token, :password, :password_confirmation, :current_password)
    #params.require(:user).permit(:password, :password_confirmation, :current_password)
    params.require(:user).permit(:password, :password_confirmation, :current_password, :zipcode, "dob(1i)", "dob(2i)","dob(3i)", :email, :username)
  end

  def save_like
    #Rails.logger.debug "In save like params =#{params.inspect}"
    Rails.logger.debug "current_user =#{current_user.inspect}"
    Rails.logger.debug "current_user  profile =#{current_user.profile.inspect}"
    Rails.logger.debug "current_user  profile LIKES =#{current_user.profile.likes.inspect}"
    unless(current_user.profile.likes.exists?(id: params[:id]))
      l = Like.new
      #l.id = current_user.profile.id
      l.like_id = params[:id]
      Rails.logger.debug "like objet =#{l.inspect}"
      current_user.profile.likes << l
      current_user.profile.save
      redirect_to profiles_path
    end
  end

  def save_unlike
    #Rails.logger.debug "In save unlike params =#{params.inspect}"
    Rails.logger.debug "current_user =#{current_user.inspect}"
    Rails.logger.debug "current_user  profile =#{current_user.profile.inspect}"
    Rails.logger.debug "current_user  profile UNLIKES =#{current_user.profile.likes.inspect}"
    profile = current_user.profile
    profile.likes.each do |l|
      Rails.logger.debug "Like object #{l.inspect}"
      Rails.logger.debug "Like object #{l.like_id.inspect}"
      Rails.logger.debug "Like object #{params[:id].inspect}"
      if(l.like_id == params[:id].to_i)
        Rails.logger.debug "Like object EQUAL"
        profile.likes.delete(l)
        Rails.logger.debug "After removal #{profile.likes.inspect}"
      end
    end
    profile.save
    redirect_to profiles_path
  end

  def confirm_email
    #Rails.logger.info "In User controller, confirm_email"
    Rails.logger.info "In  confirm_email = #{params.inspect}"
    user = User.find_by_confirm_token(params[:id])
    Rails.logger.info "In confirm_email user =#{user.inspect}"
    if user
      user.email_activate
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
      Please sign in to continue."
      # STEP_CONFIRMED_EMAIL = "Confirmed Email"
      user.profile.step_status = Profile::STEP_CONFIRMED_EMAIL
      user.profile.save!(:validate => false)
      # Removing email confirmation from second step and move to the end step
      # redirect_to profile_build_path(:about_me, :profile_id => user.profile.id)
      # Send email to all the Admins, that a new User has confirmed
      UserMailer.inform_admins_new_registration(user).deliver
      redirect_to new_session_path(user)
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to users_sign_out_path
    end
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

  def save_account_settings
    @user = current_user
    @user.referred_by = @user.profile.referred_by
    @user.dob = @user.profile.dob
    @user.zipcode = @user.profile.zipcode
    profile = Profile.find(@user.profile.id)
    profile.reason_for_match = "Jj"
    Rails.logger.info "PROFILE = #{profile.inspect}"
    profile.zipcode = user_params[:zipcode]
    profile.save!
    Rails.logger.info "In save_account_settings params =#{user_params.inspect}"
    if @user.save
      Rails.logger.info "#user =#{@user.inspect}"
      flash[:notices] = ["Your Account settings were successfully updated"]
      redirect_to user_path(@user)
    else
      flash[:notices] = ["Your account settings could not be updated"]
      render "edit_account_settings"
    end
  end  
end
