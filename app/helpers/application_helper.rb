module ApplicationHelper
    def avatar_for(user, size = 30, title = user.username)
        #image_tag user.email, size: size, title: title, class: 'img-rounded'
        resize_str = size.to_s + "x" + size.to_s
        if user.profile.avatar.attached?
            image_tag user.profile.avatar.variant(resize: resize_str)
        end
    end

    def timezone_for
        #image_tag user.email, size: size, title: title, class: 'img-rounded'
        current_user.profile.time_zone
    end
end
