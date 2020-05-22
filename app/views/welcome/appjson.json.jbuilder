# Current user information
name = {name: current_user.username}	
json.merge! name

# Current User Profile information
profile = {profile: current_user.profile}	
json.merge! profile

# List of Profiles visible to this user
profiles_list = current_user.profile.browse_profiles_list
profiles_list_json = {profiles_list: profiles_list}
json.merge! profiles_list_json