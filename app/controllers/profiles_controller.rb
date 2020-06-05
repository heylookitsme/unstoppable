class ProfilesController < ApplicationController
  before_action :authenticate_user!
  #layout "sidebar_non_admin"

  before_action :set_profile #, except: [:index, :search]
  #protect_from_forgery with: :null_session
  respond_to :json, :html, :js


  def index
    Rails.logger.debug "Profile Controller: INDEX user= #{User.current.inspect}"
    Rails.logger.debug "Profile Controller: PARAMS = #{params.inspect}"
    if current_user.blank? or current_user.profile.blank?
      return
    end
    unless params[:favorites] == "true"
      @profiles = current_user.profile.browse_profiles_list.page(params[:page])
    else
      @profiles = helpers.get_current_user_favorite_profiles
    end
    @all_profiles_total = @profiles.size unless @profiles.blank?
    @profiles_total = @all_profiles_total
   
    unless !params.has_key?(:search)  #|| (params[:min_age].blank? && params[:max_age].blank? && params[:distance].blank?)
      unless params[:search].blank?
        # Search the keyword using Postgresql search scope
        @profiles = @profiles.search_cancer_type(params[:search])
        Rails.logger.debug "Profile Controller 111: @profiles= #{@profiles}"
      end
      unless @profiles.blank?
        # Filter the search results based on Min,Max and Distance
        @min_age = (min=params[:min_age].to_i) == 0?  Profile::MIN_AGE : min
        @max_age = (max=params[:max_age].to_i) == 0?  Profile::MAX_AGE : max
        @profiles = filter_search_results
        Rails.logger.debug "Profile Controller 2222: @profiles= #{@profiles}"
        @profile_total =  @profiles.blank? ? 0:@profiles.size
      else
        @profile_total =  @profiles.blank? ? 0:@profiles.size
      end
    end
    Rails.logger.debug "Profile Controller 3333: @profiles= #{@profiles}"
    Rails.logger.debug "Profile Controller: @profile_total user= #{@profile_total}"
    respond_to do |format|
      #format.js { render partial: 'search-results'}
      format.html
      format.json
    end


      
    # Optional views
=begin
    unless params[:viewstyle].blank?
      Rails.logger.info "ViewType = #{params[:viewstyle].inspect}"
      if params[:viewstyle] == "listview"
        render "listview"
      else params[:viewstyle] == "mapview"

      end
    end
=end
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

    Rails.logger.debug "Profile Controller: Update #{@profile.inspect}"
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

  def save_like
    Rails.logger.debug "In save like params =#{params.inspect}"
    #Rails.logger.debug "current_user =#{current_user.inspect}"
    Rails.logger.debug "current_user  profile =#{current_user.profile.inspect}"
    Rails.logger.debug "current_user  profile LIKES =#{current_user.profile.likes.inspect}"
    unless(current_user.profile.likes.exists?(id: params[:like_id]))
      l = Like.new
      #l.id = current_user.profile.id
      l.like_id = params[:like_id]
      l.profile_id = params[:profile_id]
      Rails.logger.debug "like objet =#{l.inspect}"
      current_user.profile.likes << l
      current_user.profile.save
      redirect_to profiles_path
    end
  end

  def save_unlike
    #Rails.logger.debug "In save unlike params =#{params.inspect}"
    #Rails.logger.debug "current_user =#{current_user.inspect}"
    Rails.logger.debug "current_user  profile =#{current_user.profile.inspect}"
    Rails.logger.debug "current_user  profile UNLIKES =#{current_user.profile.likes.inspect}"
    profile = current_user.profile
    profile.likes.each do |l|
      Rails.logger.debug "Like object #{l.inspect}"
      Rails.logger.debug "Like object #{l.like_id.inspect}"
      Rails.logger.debug "Like object #{params[:id].inspect}"
      if(l.like_id == params[:like_id].to_i)
        Rails.logger.debug "Like object EQUAL"
        profile.likes.delete(l)
        Rails.logger.debug "After removal #{profile.likes.inspect}"
      end
    end
    profile.save
    redirect_to profiles_path
  end

  private

  def filter_search_results
    @profiles = @profiles.select{|x| x.age.to_i >= @min_age && x.age.to_i <= @max_age}
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
