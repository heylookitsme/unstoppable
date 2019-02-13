class AttachmentController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  
  layout "sidebar_non_admin"
  before_action :set_user

  def photo
    @user = current_user
    @profile = current_user.profile

  end

  def photosave
    @user = current_user
    @profile = current_user.profile
    
    @profile.avatar.attach(params[:profile][:avatar])

    if @profile.update(profile_params)
      flash[:notices] = ["Your profile avatar was successfully updated"]
      render :template => 'profiles/show.html.erb'
    else
      flash[:notices] = ["Your profile avatar could not be updated"]
      render 'photo'
    end
    #redirect_back(fallback_location: request.referer)
  end

  def delete_avatar
    @avatar = ActiveStorage::Attachment.find(params[:id])
    if @avatar.purge
      flash[:notices] = ["Your profile avatar was successfully removed"]
      render 'photo'
    else
      flash[:notices] = ["Your profile avatar could not be removed"]
      render 'photo'
    end
    #redirect_back(fallback_location: request.referer)
  end

  private

  def profile_params
    params.require(:profile).permit(
      :avatar
    )
  end

  def set_user
    @user = current_user
    @profile = current_user.profile
  end
end
