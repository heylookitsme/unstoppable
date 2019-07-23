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


user = User.create(username:"admin", email:"Ilana@2unstoppable.org", password: 'dash123', admin: true, dob: "01-01-1985", zipcode: "20854")
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

u=User.create(username:"dash", email:"sarada_chintala@hotmail.com", password: 'dash123', dob: "01-01-1942", zipcode: "20850")
u.created_at = Time.now
u.updated_at = Time.now
u.admin = true
u.save!
p = User.find_by_username("dash").profile
p.cancer_location="Breast"
p.details_about_self="I may have some thyroid nodules"
p.other_cancer_location="Lymph"
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

=begin
u=User.create(username:"dash100", email:"dash200@x.com", password: 'dash123', dob: "01-01-1942", zipcode: "20854")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash100").profile
p.cancer_location="Heart"
p.details_about_self="I may have some thyroid nodules"
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash1", email:"dash1@x.com", password: 'dash123', dob: "06-01-1959", zipcode: "20877")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash1").profile
p.cancer_location="Liver"
p.details_about_self="I may have some thyroid nodules"
p.other_cancer_location="Spleen"
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash2", email:"dash2@x.com", password: 'dash123', dob: "06-01-1958", zipcode: "22513")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash2").profile
p.cancer_location="Colon"
p.details_about_self="I may have some throat nodules"
p.other_cancer_location="Pancreas"
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash3", email:"dash3@x.com", password: 'dash123', dob: "6-12-1965", zipcode: "22436")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash3").profile
p.cancer_location="Brain"
p.details_about_self="I may have some throat nodules"
p.other_cancer_location="Neck"
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash21", email:"dash21@x.com", password: 'dash123', dob: "6-12-1950", zipcode: "20102")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash21").profile
p.cancer_location="Breast"
p.details_about_self=""
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash22", email:"dash22@x.com", password: 'dash123', dob: "6-12-1971", zipcode: "20171")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash22").profile
p.cancer_location="Breast"
p.details_about_self=""
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash23", email:"dash23@x.com", password: 'dash123', dob: "6-12-1991", zipcode: "20172")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash23").profile
p.cancer_location="Breast"
p.details_about_self=""
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash55", email:"dash55@x.com", password: 'dash123', dob: "6-12-1981", zipcode: "20172")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash55").profile
p.cancer_location="Breast"
p.details_about_self=""
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save

u=User.create(username:"dash56", email:"dash56@x.com", password: 'dash123', dob: "6-12-1981", zipcode: "22555")
u.created_at = Time.now
u.updated_at = Time.now
u.save!
p = User.find_by_username("dash56").profile
p.cancer_location="Breast"
p.details_about_self=""
p.other_cancer_location=""
p.step_status = Profile::STEP_CONFIRMED_EMAIL
p.save
=end
=begin

u.profile.zipcode="20854"
u.profile.dob="1989-01-17"
u.profile.cancer_location="Breast"
u.profile.details_about_self="Tumor in breast and stomach"
u.profile.other_cancer_location=""
u.profile.save!
u=User.create(username:"dash7", email:"sparky123@x.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20854"
u.profile.dob="1987-01-17"
u.profile.cancer_location="Breast"
u.profile.save!
u=User.create(username:"dash8", email:"dashbaby@x.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20854"
u.profile.dob="1995-01-17"
u.profile.cancer_location="Breast"
u.profile.save!
=end
