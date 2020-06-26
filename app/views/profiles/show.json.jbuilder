profile_info =  {profile: @view_profile}
json.merge! profile_info

if @view_profile.avatar.attached?
  avatar = {photo: rails_blob_path(@view_profile.avatar, disposition: "attachment")}
  json.merge! avatar
else
  json
end

activities = @view_profile.activities.blank? ? []: @view_profile.activities.collect{|x| x.name}
activities_json =  {activities: activities}
json.merge!  activities_json

exercise_reasons = @view_profile.exercise_reasons.blank? ? []: @view_profile.exercise_reasons.collect{|x| x.name}
exercise_reasons_json =  {exercise_reasons: exercise_reasons}
json.merge!  exercise_reasons_json



