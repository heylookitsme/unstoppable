class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :authenticate_user!, :except => [:show]
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
end
