class Profiles::BuildController < ApplicationController
  protect_from_forgery with: :exception
    include Wicked::Wizard
    #layout "sidebar"
    
    steps :about_me, :cancer_history
  
    def show
      Rails.logger.info "in Wizard show"
      @profile = Profile.find(params[:profile_id])
      render_wizard
    end
  
  
    def update
      Rails.logger.info "in Wizard update"
      Rails.logger.debug("Wizard update params = #{params.inspect}")
      @profile = Profile.find(params[:profile][:profile_id])
      @user = @profile.user
      prev_step_status = @profile.step_status
      Rails.logger.debug("Wizard current_step_status = #{prev_step_status.inspect}")
      @profile.update(profile_params)
      unless prev_step_status.blank?
        if Profile::STEPS_ORDER.index(prev_step_status) > Profile::STEPS_ORDER.index(@profile.step_status)
          @profile.step_status = prev_step_status
          @profile.save
          Rails.logger.info "Step status remains unchanged!"
        else
          Rails.logger.info "Change step status to #{@profile.step_status.inspect} from #{prev_step_status.inspect}"
        end
      end
      render_wizard @profile
    end

    def finish_wizard_path
      Rails.logger.debug("finish_wizard_path update params = #{params.inspect}")
      @profile = Profile.find(params[:profile_id])
      @user = @profile.user
      #set_current_user(@user) unless @user.blank?
      attachment_photo_path(:profile_id => @profile.id)
    end
  
    #def create
     # @product = Product.create
     # redirect_to wizard_path(steps.first, product_id: @product.id)
    #end
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
        :step_status,
        :which_wellness_program,
        {:exercise_reason_ids => []},
        :avatar,
        :referred_by
      )
    end
  end
  