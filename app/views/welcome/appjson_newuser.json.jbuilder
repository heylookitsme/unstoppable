# New User Profile information
unless @user.id.blank?
  json.profile @user.profile, partial: 'profiles/profile', as: :profile

  # Current user information
  name = {username: @user.username}
  json.merge! name

  email = {email: @user.email}
  json.merge! email

  id = {current_user_id: @user.id}
  json.merge! id

# Confirmation token related fields
confirm_token_json = {confirm_token: @user.confirm_token}
json.merge! confirm_token_json

email_confirmed_json = {email_confirmed: @user.email_confirmed}
json.merge! email_confirmed_json


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
else
  res = {status: "error", code:400, errors: @errors}
  response = {errors: res}
  json.merge! response
end
