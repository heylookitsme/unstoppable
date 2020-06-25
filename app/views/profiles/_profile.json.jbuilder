json.extract! profile, :id, :dob, :zipcode, :fitness_level, :cancer_location, :prefered_exercise_location, :prefered_exercise_time, :reason_for_match,
	:treatment_status, :treatment_description, :personality, :work_status, :details_about_self, :other_cancer_location, :part_of_wellness_program, :which_wellness_program,
	:created_at, :updated_at
name = {name: profile.user.username}	
json.merge! name
email = {email: profile.user.email}	
json.merge! email
age = {age: profile.age}
json.merge! age
if profile.avatar.attached?
  avatar = {photo: rails_blob_path(profile.avatar)}
  json.merge! avatar
else
  json
end
json.url profile_url(profile, format: :json)
