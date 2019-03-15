class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :except => [:show, :confirm_user]
  layout "sidebar"

  def index
    @users = User.all
  end

  def show
    Rails.logger.info("In show")
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    Rails.logger.info("1z user = #{@user.inspect}")
  end

  def first_page
    Rails.logger.info("In show")
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    Rails.logger.info("user = #{@user.inspect}")
  end

  def edit
    Rails.logger.info("In edit")
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
    Rails.logger.info("user = #{@user.inspect}")
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email)
  end

  def confirm_email
    Rails.logger.info "In User controller, confirm_email"
    Rails.logger.info "In  confirm_email = #{params.inspect}"
    user = User.find_by_confirm_token(params[:id])
    Rails.logger.info "In confirm_email user =#{user.inspect}"
    if user
      user.email_activate
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
      Please sign in to continue."
      redirect_to new_session_path(user)
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
end
end
