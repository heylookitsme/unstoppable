# Current User Profile information
json.profile current_user.profile, partial: 'profiles/profile', as: :profile

# Current user information
name = {username: current_user.username}
json.merge! name

email = {email: current_user.email}
json.merge! email

unless current_user.phone.nil?
  phone = {phone_number: current_user.phone.phone_number}
else
  phone = {phone_number: ""}
end
json.merge! phone

id = {current_user_id: current_user.id}
json.merge! id

# Avatar
if current_user.profile.avatar.attached?
  avatar = {photo: rails_blob_path(current_user.profile.avatar)}
  json.merge! avatar
else
  json
end

# Confirmation token related fields
confirm_token_json = {confirm_token: current_user.confirm_token}
json.merge! confirm_token_json

email_confirmed_json = {email_confirmed: current_user.email_confirmed}
json.merge! email_confirmed_json

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

# Unique State_Codes
unique_state_codes = profiles_list.collect{|p| p.state_code}.uniq
unique_state_codes_json = {unique_state_codes: unique_state_codes}
json.merge! unique_state_codes_json

# Unique Zip Codes
unique_zipcodes = profiles_list.collect{|p| p.zipcode}.uniq
unique_zipcodes_json = {unique_zipcodes: unique_zipcodes}
json.merge! unique_zipcodes_json

# Unique Cities
unique_cities = profiles_list.collect{|p| p.city}.uniq
unique_cities_json = {unique_cities: unique_cities}
json.merge! unique_cities_json