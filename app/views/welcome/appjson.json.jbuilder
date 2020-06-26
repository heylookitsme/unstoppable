# Current user information
name = {username: current_user.username}
json.merge! name

# Current User Profile information
profile = {profile: current_user.profile}	
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
