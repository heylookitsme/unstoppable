module ProfilesHelper

  def get_current_user_favorite_profiles
    favorites = []
      unless current_user.profile.likes.empty?
        current_user.profile.likes.each do |l|
          favorites << Profile.find(l.like_id)
        end
      end
     return favorites
  end

end
