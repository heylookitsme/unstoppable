# New User Profile information
json.profile @user.profile, partial: 'profiles/profile', as: :profile

# Current user information
name = {username: @user.username}
json.merge! name

email = {email: @user.email}
json.merge! email

id = {current_user_id: @user.id}
json.merge! id

