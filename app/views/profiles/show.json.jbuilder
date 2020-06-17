profile = {profile: current_user.profile}
json.merge! profile

if @profile.avatar.attached?
  json.merge! {photo: rails_blob_path(@profile.avatar, disposition: "attachment")}
else
  json
end