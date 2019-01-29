class AttachmentController < ApplicationController
  !before_filter :authenticate_user!, :except => [:index]
  #before_filter :correct_user, :only [:edit, :update]
  layout "sidebar"

  before_filter :authenticate_user!

  def photo
    @user = current_user
    @profile = current_user.profile

    unless @profile.avatar.present?
      @profile.remove_avatar!
    end

  end

  def photosave
    @user = current_user
    @profile = current_user.profile

    unless @profile.avatar.present?
      @profile.remove_avatar!
    end

    if @profile.update(profile_params)
      flash[:notices] = ["Your profile was successfully updated"]
      render 'photo'
    else
      flash[:notices] = ["Your profile could not be updated"]
      render 'photo'
    end
  end

  private

  def profile_params
    Rails.logger.debug("in profile params")
    Rails.logger.debug("#{params.inspect}")
    params.require(:profile).permit(
      :avatar,
      :remove_avatar
    )
  end

  def set_user
    @user = current_user
    @profile = current_user.profile
  end
end
