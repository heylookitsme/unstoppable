json.extract! profile, :id, :dob, :zipcode, :fitness_level, :cancer_location, :prefered_exercise_location, :prefered_exercise_time, :reason_for_match,
	:treatment_status, :treatment_description, :personality, :work_status, :details_about_self, :other_cancer_location, :part_of_wellness_program, :which_wellness_program,
	:created_at, :updated_at
json.url profile_url(profile, format: :json)
