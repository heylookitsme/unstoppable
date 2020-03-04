module ConversationHelper
  def recipients_options
    s = ''
    User.all.each do |user|
      s << "<option value='#{user.id}' data-img=<%= avatar_for(user, 30) %>#{user.username}, age: #{user.profile.age}, location: #{user.profile.city}</option>"
    end
    s.html_safe
  end
end