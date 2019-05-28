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

user = User.create(username:"admin", email:"test@test.com", password: 'dash123', admin: true, dob: "01-01-1985", zipcode: "20854")
user.profile.cancer_location="Lung"
user.profile.details_about_self="I may have some thyroid nodules"
user.profile.other_cancer_location="Bladder"
user.save!


u=User.create(username:"dash", email:"dashcute@x.com", password: 'dash123', dob: "01-01-1942", zipcode: "20850")
u.profile.cancer_location="Breast"
u.profile.details_about_self="I may have some thyroid nodules"
u.profile.other_cancer_location="Lymph"
u.save!
p = User.find_by_username("dash").profile
p.moderated=true
p.save

u=User.create(username:"dash100", email:"dash200@x.com", password: 'dash123', dob: "01-01-1942", zipcode: "20854")
u.profile.cancer_location="Breast"
u.profile.details_about_self="I may have some thyroid nodules"
u.profile.other_cancer_location="Lymph"
u.save!

u=User.create(username:"dash1", email:"dash1@x.com", password: 'dash123', dob: "06-01-1959", zipcode: "20877")
u.profile.cancer_location="Liver"
u.profile.details_about_self="I may have some throat nodules"
u.profile.other_cancer_location="Spleen"
u.save!
p = User.find_by_username("dash1").profile
p.moderated=true
p.save


u=User.create(username:"dash2", email:"dash2@x.com", password: 'dash123', dob: "06-01-1958", zipcode: "22513")
u.profile.cancer_location="Colon"
u.profile.details_about_self="I may have some throat nodules"
u.profile.other_cancer_location="Pancreas"
u.save!
p = User.find_by_username("dash2").profile
p.moderated=true
p.save

u=User.create(username:"dash3", email:"dash3@x.com", password: 'dash123', dob: "6-12-1965", zipcode: "22436")
u.profile.cancer_location="Brain"
u.profile.details_about_self="I may have some throat nodules"
u.profile.other_cancer_location="Neck"
u.save!
p = User.find_by_username("dash3").profile
p.moderated=true
p.save

u=User.create(username:"dash21", email:"dash21@x.com", password: 'dash123', dob: "6-12-1950", zipcode: "20102")
u.profile.cancer_location="Breast"
u.profile.details_about_self=""
u.profile.other_cancer_location=""
u.save!
p = User.find_by_username("dash21").profile
p.moderated=true
p.save

u=User.create(username:"dash22", email:"dash22@x.com", password: 'dash123', dob: "6-12-1971", zipcode: "20171")
u.profile.cancer_location="Breast"
u.profile.details_about_self=""
u.profile.other_cancer_location=""
u.save!
p = User.find_by_username("dash22").profile
p.moderated=true
p.save

u=User.create(username:"dash23", email:"dash23@x.com", password: 'dash123', dob: "6-12-1991", zipcode: "20172")
u.profile.cancer_location="Breast"
u.profile.details_about_self=""
u.profile.other_cancer_location=""
u.save!
p = User.find_by_username("dash23").profile
p.moderated=true
p.save

u=User.create(username:"dash55", email:"dash55@x.com", password: 'dash123', dob: "6-12-1981", zipcode: "20172")
u.profile.cancer_location="Breast"
u.profile.details_about_self=""
u.profile.other_cancer_location=""
u.save!
p = User.find_by_username("dash55").profile
p.moderated=true
p.save

u=User.create(username:"dash56", email:"dash56@x.com", password: 'dash123', dob: "6-12-1981", zipcode: "22555")
u.profile.cancer_location="Breast"
u.profile.details_about_self=""
u.profile.other_cancer_location=""
u.save!
p = User.find_by_username("dash56").profile
p.moderated=true
p.save
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
