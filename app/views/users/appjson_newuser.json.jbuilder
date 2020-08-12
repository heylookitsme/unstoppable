# New User Profile information
json.profile @user.profile, partial: 'profiles/profile', as: :profile

# Current user information
name = {username: @user.username}
json.merge! name

email = {email: @user.email}
json.merge! email

id = {current_user_id: @user.id}
json.merge! id

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

