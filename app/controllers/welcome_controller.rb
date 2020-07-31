class WelcomeController < ApplicationController

  def index
    if current_user.blank?
      redirect_to new_user_session_path
    else
      if current_user.profile.step_status == Profile::STEP_CONFIRMED_EMAIL
        redirect_to profiles_path
      else
        case current_user.profile.step_status
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
    end
  end

  def appjson
    Rails.logger.debug("In Welcome controller, appjson action. Current user = #{current_user.inspect}")
  end

end
