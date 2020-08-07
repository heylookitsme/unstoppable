json.extract! profile, :id, :dob, :zipcode, :fitness_level, :cancer_location, :prefered_exercise_location, :prefered_exercise_time, :reason_for_match,
	:treatment_status, :treatment_description, :personality, :work_status, :details_about_self, :other_cancer_location, :part_of_wellness_program, :which_wellness_program,
  :city, :state, :country, :state_code, :distance, :time_zone, :virtual_partner,
	:created_at, :updated_at
name = {name: profile.user.username}	
json.merge! name

email = {email: profile.user.email}	
json.merge! email

age = {age: profile.age}
json.merge! age

activities = profile.activities.blank? ? []: profile.activities.collect{|x| x.id}
activities_json =  {activity_ids: activities}
json.merge!  activities_json

exercise_reasons = profile.exercise_reasons.blank? ? []: profile.exercise_reasons.collect{|x| x.id}
exercise_reasons_json =  {exercise_reason_ids: exercise_reasons}
json.merge!  exercise_reasons_json


likes = profile.likes.blank? ? []: profile.likes.collect{|x| x.like_id}
likes_json =  {liked_profiles: likes}
json.merge!  likes_json

if profile.avatar.attached?
  avatar = {photo: rails_blob_path(profile.avatar)}
  json.merge! avatar
else
  json
end
json.url profile_url(profile, format: :json)
