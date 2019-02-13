class ProfilesController < ApplicationController
  !before_action :authenticate_user!, :except => [:index]
  #before_filter :correct_user, :only [:edit, :update]
  layout "sidebar_non_admin"

  #before_filter :authenticate_user!
  before_action :set_profile, except: [:index, :search]
  protect_from_forgery with: :null_session

  def index
    @profiles = Profile.all
  end

  
  def show
  
  end

  def edit
   
  end

  def update
   
     unless @profile.avatar.present?
      @profile.remove_avatar!
    end

    if @profile.update(profile_params)
      flash[:notices] = ["Your profile was successfully updated"]
      render 'show'
    else
      flash[:notices] = ["Your profile could not be updated"]
      render 'edit'
    end
  end

  # GET profiles/search

  def search
    @profiles = Profile.search do
      keywords params[:query]
    end.results

    respond_to do |format|
      format.html { render :action => "index" }
    end
  end


  private

  def profile_params
    params.require(:profile).permit(
      :dob, :zipcode,
      {:activity_ids => []},
      :other_favorite_activities,
      :fitness_level, :cancer_location, 
      :prefered_exercise_location, :prefered_exercise_time, 
      :reason_for_match, :treatment_status, :treatment_description, :personality, 
      :work_status, 
      :details_about_self, :other_cancer_location,
      :part_of_wellness_program,
      :which_wellness_program,
      {:exercise_reason_ids => []},
      :avatar
    )
  end

  def set_profile
    Rails.logger.debug("IN SET_USER")
    Rails.logger.debug("params = #{params.inspect}")
   # unless params[:user_id].nil?
      # Editing the profile from the user screens
    #  @user = User.find_by_id(params[:user_id])
   #   @profile = @user.profile
  #  else
      @profile = Profile.find(params[:id])
      #@user = @profile.user

      Rails.logger.debug("SARADA = #{@profile.inspect}")
   # end
  end
end
