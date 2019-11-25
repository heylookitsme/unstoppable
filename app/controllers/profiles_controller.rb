class ProfilesController < ApplicationController
  before_action :authenticate_user!
  #layout "sidebar_non_admin"

  before_action :set_profile #, except: [:index, :search]
  #protect_from_forgery with: :null_session


  def index
    Rails.logger.debug "Profile Controller: INDEX user= #{User.current.inspect}"
    Rails.logger.debug "Profile Controller: PARAMS = #{params.inspect}"
    unless current_user.blank? or current_user.profile.blank?
      @profiles = Profile.where(["id != ? and step_status = ?", current_user.profile.id, Profile::STEP_CONFIRMED_EMAIL]).order("updated_at DESC").page(params[:page])
      @profiles_total = @profiles.size unless @profiles.blank?
      case current_user.profile.step_status
        when Profile::STEP_CONFIRMED_EMAIL
          @profiles = Profile.where(["id != ? and step_status = ?", current_user.profile.id, Profile::STEP_CONFIRMED_EMAIL]).order("updated_at DESC").page(params[:page])
          unless !params.has_key?(:search)  || (params[:min_age].blank? && params[:max_age].blank? && params[:distance].blank?)
            @profiles_total = @profiles.size unless @profiles.blank?
            unless params[:search].blank?
              @search_results_profiles = @profiles.search_cancer_type(params[:search])
            else
              @search_results_profiles = @profiles
            end
            unless @search_results_profiles.blank?
              @search_results_profiles = process_search
            end
            @search_results_total = 0
            @search_results_total = @search_results_profiles.size unless @search_results_profiles.blank?
            respond_to do |format|
              format.js { render partial: 'search-results'}
            end
          else
            @search_results_profiles = @profiles
          end
        when Profile::STEP_EMAIL_CONFIRMATION_SENT
          redirect_to remind_confirmation_user_path(current_user)
        when Profile::STEP_CANCER_HISTORY
          redirect_to attachment_photo_path(:profile_id => current_user.profile.id)
        when Profile::STEP_ABOUT_ME
          redirect_to profile_build_path(:cancer_history, :profile_id => current_user.profile.id)
        when Profile::STEP_BASIC_INFO
          redirect_to profile_build_path(:about_me, :profile_id => current_user.profile.id)
      end
    end
    # Optional views
    unless params[:viewstyle].blank?
      Rails.logger.info "ViewType = #{params[:viewstyle].inspect}"
      if params[:viewstyle] == "listview"
        render "listview"
      else params[:viewstyle] == "mapview"

      end
    end
  end

  
  def show
  
  end

  def thank_you
    Rails.logger.debug "Profile Controller: Thank you #{@profile.inspect}"
    @user = current_user
    @profile.wizard_complete_thankyou_sent = true
    @profile.save!
    render 'thank_you'
  
  end

  def approval
    UserMailer.registration_confirmation(resource).deliver
  end

  def edit
   
  end

  def update

    #Rails.logger.debug "Profile Controller: Update #{@profile.inspect}"
    Rails.logger.debug "Profile Controller: Update #{params.inspect}"
   
    unless @profile.avatar.present?
      @profile.remove_avatar!
    end
    previous_step = @profile.step_status
    if @profile.update(profile_params)
      flash[:notices] = ["Your profile was successfully updated"]
      render 'show'
    else
      flash[:notices] = ["Your profile could not be updated"]
      render 'edit'
    end
  end

  # GET profiles/search

=begin This is the SOLR search
  def search
    Rails.logger.debug 'In search'
    user = current_user
    min_age = params["min_age"].blank? ? 0:params["min_age"].to_i
    max_age = params["max_age"].blank? ? 200:params["max_age"].to_i
    distance = params["distance"].blank? ? 2000:params["distance"].to_i
    
    @profiles = Profile.search do
      with(:age, min_age..max_age)
      with(:distance, 0..distance)
      #with(:zipcode).in_radius(current_user.profile.latitude, current_user.profile.longitude, 100)
      keywords params[:query]
    end.results

    if distance > 0
      @profiles = @profiles.select{|x| x.distance && x.distance <= distance}
    end
    
    respond_to do |format|
      format.html { render :action => "index" }
    end
  end
=end

  private

  def process_search
    unless params["min_age"].blank? && params["max_age"].blank?
      @min_age = params["min_age"].blank? ? Profile::MIN_AGE : params["min_age"].to_i
      @max_age = params["max_age"].blank? ? Profile::MAX_AGE : params["max_age"].to_i
      # if the user has given a string input instead of a number
      @max_age = Profile::MAX_AGE if @max_age == 0
      @min_age = Profile::MIN_AGE if @min_age == 0
      @search_results_profiles = @search_results_profiles.select{|x| x.age.to_i >= @min_age && x.age.to_i <= @max_age}
    end
    unless params["distance"].blank?
      @distance = params["distance"].blank? ? 2000:params["distance"].to_i
      culat = current_user.profile.latitude
      culong = current_user.profile.longitude
      @search_results_profiles.each do |profile|
        if !culat.nil? && !culong.nil? && !profile.latitude.nil? && !profile.longitude.nil?
            d =  Geocoder::Calculations.distance_between([culat, culong], [profile.latitude, profile.longitude])
            profile.distance = d.round
        end
      end
      if @distance > 0
        @search_results_profiles = @search_results_profiles.select{|x| x.distance <= @distance}
      end
    end
    @search_results_profiles
  end

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
      :avatar,
      :referred_by,
      :id
    )
  end

  def set_profile
    Rails.logger.debug("IN SET_USER")
    Rails.logger.debug("params = #{params.inspect}")
    unless params[:id].blank?
      @profile = Profile.find(params[:id])
      @user = @profile.user
      Rails.logger.debug("SARADA = #{@profile.inspect}")
    else
      unless params[:user_id].blank?
        @user = User.find(params[:user_id])
        @profile = @user.profile
      else
        if(current_user.blank?)
          redirect_to destroy_user_session_path and return
        else
          @user = current_user
        end
      end
    end
  end
  
end
