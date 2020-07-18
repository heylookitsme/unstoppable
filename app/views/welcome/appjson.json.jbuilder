# Current User Profile information
json.profile current_user.profile, partial: 'profiles/profile', as: :profile

# Current user information
name = {username: current_user.username}
json.merge! name

email = {email: current_user.email}
json.merge! email

id = {current_user_id: current_user.id}
json.merge! id

# Avatar
if current_user.profile.avatar.attached?
  avatar = {photo: rails_blob_path(current_user.profile.avatar)}
  json.merge! avatar
else
  json
end
# List of Profiles visible to this user
profiles_list = current_user.profile.browse_profiles_list
profiles_list_json = {profiles_list: profiles_list}
json.merge! profiles_list_json

# All Exercise reasons
all_exercise_reasons_json = []
ExerciseReason.all.each do |e|
   all_exercise_reasons_json << {id: e.id, name: e.name}
end
exercise_json = {all_exercise_reasons: all_exercise_reasons_json}
json.merge! exercise_json

# All Activities
all_activities_json = []
Activity.all.each do |a|
  all_activities_json << {id: a.id, name: a.name}
end
activity_json = {all_activities: all_activities_json}
json.merge! activity_json