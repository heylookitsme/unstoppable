class ProfilesController < ApplicationController
  !before_action :authenticate_user!, :except => [:index]
  #before_filter :correct_user, :only [:edit, :update]
  layout "sidebar_non_admin"

  #before_filter :authenticate_user!
  before_action :set_profile, except: [:index, :search]
  protect_from_forgery with: :null_session

  def index
    #@profiles = Profile.all
    @profiles = Profile.get_list
  end

  
  def show
  
  end

  def edit
   
  end

  def update

    Rails.logger.debug "Profile Controller: Update #{@profile.inspect}"
    Rails.logger.debug "Profile Controller: Update #{params.inspect}"
   
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
    Rails.logger.debug "PARAMS = #{params.inspect}"
    min_age = params["min_age"].blank? ? 0:params["min_age"].to_i
    max_age = params["max_age"].blank? ? 200:params["max_age"].to_i
    Rails.logger.debug "#{min_age.inspect}"
    Rails.logger.debug "#{max_age.inspect}"
    @profiles = Profile.search do
      with(:age, min_age..max_age)
      keywords params[:query]
    end.results

    for profile in @profiles do
      #profile.set_age
    end

    #Rails.logger.debug "Profiles = #{@profiles.inspect}"

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
