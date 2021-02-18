class AttachmentController < ApplicationController
  before_action :set_user, :except => [:photosavejson]
  skip_before_action :verify_authenticity_token
  #before_action :authenticate_user! 

  respond_to  :json, :html
  

  def photo
    #Rails.logger.debug("attchment controller photo action params = #{params.inspect}")
  end

  def photosave
    #@user = current_user
    #@profile = current_user.profile
    Rails.logger.debug("attachment controller photosave params = #{params.inspect}")
    if @profile.blank?
      return
    end
    
    if !params[:profile].blank? && !params[:profile][:avatar].blank?
      @profile.avatar.attach(params[:profile][:avatar])
      if @profile.update(profile_params)
        flash[:notices] = ["Your profile avatar was successfully updated"]
      else
        flash[:notices] = ["Your profile avatar could not be updated"]
      end
    end
    unless @profile.step_status == Profile::STEP_CONFIRMED_EMAIL
      # Removing email confirmation from second step and move to the end step
      # render :template => 'profiles/thank_you.html.erb'
      redirect_to email_confirmation_user_path(@user)
    else
      #respond_to do |format|
        #redirect_to attachment_photo_path(:profile_id => @profile.id)
        redirect_to profile_path(@profile)
        #format.js
      #end
    end
  end

  def photosavejson
    Rails.logger.debug("attachment controller photosave params = #{params.inspect}")
    @user  = User.find(params[:id])
    @profile = @user.profile
    unless params[:file].blank? 
      @profile.avatar.attach(params[:file])
      photo = url_for(@profile.avatar)
      #if @profile.update(avatar: photo)
        render :json => {"photo" => photo, "status" => 200, "message" => "Attachment Successful"}
      #else
       # render :json => {"status" => "error", "code" => 400, "message" => profile.errors[:avatar].to_s}
      #end
      
    end
  end

  def delete_avatar
    #@avatar = ActiveStorage::Attachment.find(params[:id])
    @avatar = @profile.avatar
    @avatar.purge
    unless @profile.step_status == Profile::STEP_CONFIRMED_EMAIL
      @profile.step_status = Profile::STEP_CANCER_HISTORY
      @profile.save
      flash[:notices] = ["Your profile avatar was successfully removed"]
      render 'photo'
    else
      @profile.save
      flash[:notices] = ["Your profile avatar was successfully removed"]
      redirect_to profile_path(@profile)
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
      Rails.logger.debug("In Profile Controller @profile = #{@profile.inspect}")
      @user = @profile.user
      Rails.logger.debug("In Profile Controller @user = #{@user.inspect}")
    else
      @profile = Profile.find_by_id(params["id"])
      @user = @profile.user
    end
   
  end
end
