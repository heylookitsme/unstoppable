profile = {profile: current_user.profile}
json.merge! profile

if @profile.avatar.attached?
  avatar = {photo: rails_blob_path(@profile.avatar, disposition: "attachment")}
  json.merge! avatar
else
  json
end