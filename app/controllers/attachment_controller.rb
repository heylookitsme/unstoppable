class AttachmentController < ApplicationController
  before_action :authenticate_user!

  #layout "sidebar_non_admin"
  before_action :set_user 

  def photo
    Rails.logger.debug("attchment controller photo action params = #{params.inspect}")
  end

  def photosave
    #@user = current_user
    #@profile = current_user.profile
    
    @profile.avatar.attach(params[:profile][:avatar])
   

    if @profile.update(profile_params)
      flash[:notices] = ["Your profile avatar was successfully updated"]
      @profile.step_status = "Photo Attached"
      @profile.save
      unless @profile.moderated?
        render :template => 'profiles/thank_you.html.erb'
      else
        render :template => 'profiles/show.html.erb'
      end
    else
      flash[:notices] = ["Your profile avatar could not be updated"]
      render 'photo'
    end
    #redirect_back(fallback_location: request.referer)
  end

  def delete_avatar
    #@avatar = ActiveStorage::Attachment.find(params[:id])
    @avatar = @profile.avatar
    #@profile = @avatar.record
    if @avatar.purge
      @profile.step_status = "Cancer History"
      @profile.save
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
      :avatar,
      :user_id
    )
  end

  def set_user
    Rails.logger.debug("attchment controller set_user params = #{params.inspect}")
    unless params["profile_id"].blank?
      # The action has been called by the wizard 
      @profile = Profile.find_by_id(params["profile_id"])
      @user = @profile.user
      set_current_user(@user)
    else
      @profile = Profile.find_by_id(params["id"])
      @user = @profile.user
      set_current_user(@user)
    end
   
  end
end
