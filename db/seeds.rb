# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Activity.find_or_create_by!(name: 'Walking')
Activity.find_or_create_by!(name: 'Running')
Activity.find_or_create_by!(name: 'Cycling')
Activity.find_or_create_by!(name: 'Weight Lifting')
Activity.find_or_create_by!(name: 'Aerobics')
Activity.find_or_create_by!(name: 'Swimming')
Activity.find_or_create_by!(name: 'Team Sports')
Activity.find_or_create_by!(name: 'Yoga')
Activity.find_or_create_by!(name: 'Pilates')
Activity.find_or_create_by!(name: 'Gardening')

ExerciseReason.find_or_create_by!(name: 'Weight Loss')
ExerciseReason.find_or_create_by!(name: 'Social Support')
ExerciseReason.find_or_create_by!(name: 'Reduce Pain')
ExerciseReason.find_or_create_by!(name: 'Reduce Fatigue')
ExerciseReason.find_or_create_by!(name: 'Emotional Health')
ExerciseReason.find_or_create_by!(name: 'Physical Health')
ExerciseReason.find_or_create_by!(name: 'Sense of Accomplishment')
ExerciseReason.find_or_create_by!(name: 'Other  - Describe in About You question below')

=begin
user = User.create(username:"tars", email:"rukmini_r@yahoo.com", password: 'Dash1234', admin: true, dob: "01-01-1985", zipcode: "20854", terms_of_service: "1", referred_by: 'Web search')
user.save!
user.profile.cancer_location="Lung"
user.profile.details_about_self="I may have some thyroid nodules"
user.profile.other_cancer_location="Bladder"
user.created_at = Time.now
user.updated_at = Time.now
p = User.find_by_username("admin").profile
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.fitness_level = "very active"
p.save
=end


u=User.create(username:"dash", email:"sarada_chintala@hotmail.com", password: 'Dash1234', dob: "01-01-1942", zipcode: "20850", terms_of_service: "1", referred_by: 'Web search')
u.created_at = Time.now
u.updated_at = Time.now
u.admin = true
u.email_confirmed=true
u.save!
p = User.find_by_username("dash").profile
p.cancer_location="Breast"
p.details_about_self="I may have some thyroid nodules"
p.other_cancer_location="Lymph"
p.reason_for_match="fitness bussy"
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save


