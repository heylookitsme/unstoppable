class ProfilesController < ApplicationController
  !before_action :authenticate_user!, :except => [:index]
  #before_filter :correct_user, :only [:edit, :update]
  layout "sidebar"

  #before_filter :authenticate_user!
  before_action :set_user
  protect_from_forgery with: :null_session

  def show
  end

  def edit
    @user = current_user
    @profile = current_user.profile
  end

  def update
    user = current_user
    @profile = current_user.profile
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

  def set_user
    Rails.logger.debug("IN SET_USER")
    @user = current_user
    @profile = current_user.profile
  end
end
