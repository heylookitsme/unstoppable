# Current user information
name = {username: current_user.username}
json.merge! name

email = {email: current_user.email}
json.merge! email

# Current User Profile information
profile = {profile: current_user.profile}	
activities = current_user.profile.activities.blank? ? []: current_user.profile.activities.collect{|x| x.id}
activities_json =  {activity_ids: activities}
profile.merge!  activities_json

exercise_reasons = current_user.profile.exercise_reasons.blank? ? []: current_user.profile.exercise_reasons.collect{|x| x.id}
exercise_reasons_json =  {exercise_reason_ids: exercise_reasons}
profile.merge!  exercise_reasons_json

# After merging the activites and exercise reasons
json.merge! profile

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