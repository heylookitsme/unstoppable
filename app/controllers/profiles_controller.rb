class ProfilesController < ApplicationController
  before_action :authenticate_user! #, except: [:update_steps_json]
  #layout "sidebar_non_admin"

  before_action :set_profile, except: [:show, :update_steps_json] #, except: [:index, :search]
  
  #protect_from_forgery with: :null_session
  respond_to :json, :html, :js


  def index
    #Rails.logger.debug "Profile Controller: INDEX user= #{User.current.inspect}"
    Rails.logger.debug "Profile Controller: PARAMS = #{params.inspect}"
    if current_user.blank? or current_user.profile.blank?
      return
    end
    #Get all confirmed profiles, excluding self
    @profiles = Profile.except_self(current_user.profile.id).confirmed
    # Get all the Active users
    if params[:active] == "true"
      @profiles = @profiles.where(user_id: User.last_seen.pluck(:id))
    end
    @all_profiles_total = @profiles.size unless @profiles.blank?
    @profiles_total = @all_profiles_total

    Rails.logger.debug("all profiles = #{@profiles.inspect}")
    @profiles = @profiles.search_all_words(params[:keywordsSelect]) unless params[:keywordsSelect].blank?
    unless !params.has_key?(:search)  #|| (params[:min_age].blank? && params[:max_age].blank? && params[:distance].blank?)
      unless params[:search].blank?
        # Search the keyword using Postgresql search scope
        keyword_search_type =  params[:keyword_search_type] || "OR"
=begin         
        if params[:keyword_search_type] == "OR"
          @profiles = @profiles.search_any_word(params[:search])
        else
          @profiles = @profiles.search_all_words(params[:search])
        end
=end
        
        if params[:keyword_search_type] == "OR" && !params[:search].blank?
          @profiles = @profiles.search_any_word(params[:search])
        else
          @profiles = @profiles.search_all_words(params[:search])
        end
        
        Rails.logger.debug(" Keyword select profiles  = #{@profiles.inspect}")

      end
    end

    unless @profiles.blank?
      # Filter the search results based on Min,Max and Distance
      @min_age = (min=params[:min_age].to_i) == 0?  Profile::MIN_AGE : min
      @max_age = (max=params[:max_age].to_i) == 0?  Profile::MAX_AGE : max
      @profiles = filter_search_results
      @profile_total =  @profiles.blank? ? 0:@profiles.size
    else
      @profile_total =  @profiles.blank? ? 0:@profiles.size
    end
   
    # Sort options
    unless @profiles.blank?
      unless params[:distanceOrder].blank?
        Rails.logger.debug "DISTANCE"
        if params[:distanceOrder] == "asc"
          @profiles = @profiles.sort {|a,b| a.distance <=> b.distance}
        else
          @profiles = @profiles.sort {|a,b| a.distance <=> b.distance}.reverse
        end
      end
      unless params[:ageOrder].blank?
        Rails.logger.debug "AGE"
        if params[:ageOrder] == "asc"
          @profiles = @profiles.sort {|a,b| a.age <=> b.age}
        else
          @profiles = @profiles.sort {|a,b| a.age <=> b.age}.reverse
        end
      end
      unless params[:newestMemberOrder].blank?
        Rails.logger.debug "newestMemberOrder"
        if params[:newestMemberOrder] == "asc"
          @profiles = @profiles.sort {|a,b| a.created_at <=> b.created_at}
        else
          @profiles = @profiles.sort {|a,b| a.created_at <=> b.created_at}.reverse
        end
      end
      unless params[:lastOnlineOrder].blank?
        Rails.logger.debug "lastOnlineOrder"
        if params[:lastOnlineOrder] == "asc"
          @profiles = @profiles.sort {|a,b| a.updated_at <=> b.updated_at}
        else
          @profiles = @profiles.sort {|a,b| a.updated_at <=> b.updated_at}.reverse
        end
      end
    end

    Rails.logger.debug("profiles to display = #{@profiles.inspect}")
    # Compute number of profiles
    @profiles_size = @profiles.size
    # Pagination with Autoscroll in Reactjs Front end
    @profiles = @profiles.slice((12*params[:page].to_i) - 12, 12)
 
    Rails.logger.debug("profiles after page slicing = #{@profiles.inspect}")

    respond_to do |format|
      format.html
      format.json
    end
  end

  
  def show
    Rails.logger.debug "Profile Controller:, action: show, PARAMS = #{params.inspect}"
    Rails.logger.debug "Profile Controller: action:show, current_user = #{current_user.inspect}"
    # Profile to be displayed can be selected in two ways:
    # 1) View current user profile
    # 2) One of the profiles in Browse Profile is viewed.
    @view_profile = Profile.find(params[:id])
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
    #Rails.logger.debug "Profile Controller: Update #{params["profile"]["liked_profiles"].inspect}"
    unless @profile.avatar.present?
      @profile.remove_avatar!
    end
    liked_profiles = params["profile"]["liked_profiles"]
    @profile.likes = []
    unless liked_profiles.blank?
      liked_profiles = params["profile"]["liked_profiles"]
      liked_profiles.each do |l|
        liked_profile = Like.new
        liked_profile.like_id = l
        liked_profile.profile_id = @profile.id
        @profile.likes << liked_profile
      end
    end
    if @profile.update(profile_params)
      flash[:notices] = ["Your profile was successfully updated"]
      @view_profile = @profile
      respond_to do |format|
        #format.js { render partial: 'search-results'}
        format.html {redirect_to profile_path}
        format.json { render :json => @profile }
      end
    else
      flash[:notices] = ["Your profile could not be updated"]
      render 'edit'
    end
   
  end

  # JSON response for updating steps
  def update_steps_json
    Rails.logger.debug("Wizard update params = #{params.inspect}")
    Rails.logger.debug("Wizard update params = #{params["profile"]["id"].inspect}")
    return if  params["profile"].blank? || params["profile"]["id"].blank?
    @profile = Profile.find(params[:profile][:id])
    @profile.update(profile_params)
    @profile.save
    respond_to do |format|
      format.json { head :ok }
    end
  end

  
  #############################
   # This action is only used by the Rails server App. TODO: Remove
  #############################
  def save_like
    unless(current_user.profile.likes.exists?(id: params[:like_id]))
      l = Like.new
      l.like_id = params[:like_id]
      l.profile_id = current_user.profile.id
      current_user.profile.likes << l
      current_user.profile.save
      redirect_to profiles_path
    end
  end

  ###########################
  #This action is only used by the Rails server App. TODO: Remove
  ############################
  def save_unlike
  
    profile = current_user.profile
    profile.likes.each do |l|
      if(l.like_id == params[:like_id].to_i)
        profile.likes.delete(l)
      end
    end
    profile.save
    redirect_to profiles_path
  end

  private

  def filter_search_results
    @profiles = @profiles.select{|x| x.age.to_i >= @min_age && x.age.to_i <= @max_age}
    #Rails.logger.debug(" filter_search_results profiles  = #{@profiles.inspect}")
    unless params["distance"].blank?
      @distance = params["distance"].to_i
      culat = current_user.profile.latitude
      culong = current_user.profile.longitude
      @profiles.each do |profile|
        if !culat.nil? && !culong.nil? && !profile.latitude.nil? && !profile.longitude.nil?
            d =  Geocoder::Calculations.distance_between([culat, culong], [profile.latitude, profile.longitude])
            profile.distance = d.round
        end
      end
      if @distance > 0
        @profiles = @profiles.select{|x| x.distance <= @distance}
      end
    end
    @profiles
  end

  def profile_params
    params.require(:profile).permit(
      :page,
      :dob, :zipcode,
      {:activity_ids => []},
      :other_favorite_activities,
      :virtual_partner,
      :fitness_level, :cancer_location, 
      :prefered_exercise_location, :prefered_exercise_time, 
      :reason_for_match, :treatment_status, :treatment_description, :personality, 
      :work_status, 
      :details_about_self, :other_cancer_location,
      :part_of_wellness_program,
      :which_wellness_program,
      :step_status,
      {:exercise_reason_ids => []},
      {:liked_profiles => []},
      :avatar,
      :referred_by,
      :id
    )
  end

  def set_profile
    Rails.logger.debug("IN SET_PROFILE")
    Rails.logger.debug("params = #{params.inspect}")
    unless params[:id].blank?
      @profile = Profile.find(params[:id])
      @user = @profile.user
    else
      # This path is only used when another user is sent a message
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
