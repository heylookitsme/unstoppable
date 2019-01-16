class ProfilesController < ApplicationController
  !before_filter :authenticate_user!, :except => [:index]
  #before_filter :correct_user, :only [:edit, :update]
  layout "sidebar"

  before_filter :authenticate_user!
  protect_from_forgery with: :null_session

  def show
    @profile = Profile.find_by(user_id: params[:user_id])
    @user = User.find_by(id: params[:user_id])
    Rails.logger.info("In Profile Constroller show #{@user.inspect}")
  end

  def edit
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def update
    Rails.logger.info("In UPDATE #{params[:user_id]}")
    @profile = Profile.find_by(user_id: params[:user_id])
    @user = User.find_by(id: params[:user_id])
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
      {:exercise_reason_ids => []}
    )
  end
end
