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


#u=User.new(username:"dash", email:"dashcute@x.com", password: 'dash123')
#u.skip_confirmation!
=begin
u.save!
u.profile.zipcode="20854"
u.profile.dob="1944-01-17"
u.profile.cancer_location="Lung"
u.profile.details_about_self="I may have some thyroid nodules"
u.profile.other_cancer_location="Bladder"
u.profile.save!
#end

=begin
u=User.create(username:"dash1", email:"dashsweet@x.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20850"
u.profile.dob="1984-01-17"
u.profile.cancer_location="Lung"#
u.profile.details_about_self="I may have some nodules in the throat"
u.profile.other_cancer_location="Spleen"
u.profile.save!
u=User.create(username:"dash2", email:"sarada_chintala@hotmail.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20877"
u.profile.dob="1994-01-17"
u.profile.cancer_location="Lung"
u.profile.details_about_self="I may have some tumor near the thigh"
u.profile.other_cancer_location="skin"
u.profile.save!
u=User.create(username:"dash3", email:"shardax@gmail.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20854"
u.profile.dob="1999-01-17"
u.profile.cancer_location="Lung"
u.profile.details_about_self="Feeling fatigue"
u.profile.other_cancer_location="bone"
u.profile.save!
u=User.create(username:"dash4", email:"saradarails@gmail.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20854"
u.profile.dob="1992-01-17"
u.profile.cancer_location="Lung"
u.profile.details_about_self="I am a vegitarian"
u.profile.other_cancer_location="kidney"
u.profile.save!
u=User.create(username:"dash5", email:"dashsparky@gmail.com", password: 'dash123')
u.skip_confirmation!
u.save!
u.profile.zipcode="20854"
u.profile.dob="1990-01-17"
u.profile.cancer_location="Breast"
u.profile.details_about_self="I may have some nodules in the lymph nodes"
u.profile.other_cancer_location="Colon"
u.profile.save!
u=User.create(username:"dash6", email:"sparkydash@x.com", password: 'dash123')
u.skip_confirmation!
u.save!
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
