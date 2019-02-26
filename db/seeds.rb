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
Activity.find_or_create_by!(name: 'Pilates')
Activity.find_or_create_by!(name: 'Gardening')
Activity.find_or_create_by!(name: 'Team Sports')
Activity.find_or_create_by!(name: 'Pilates')
Activity.find_or_create_by!(name: 'Yoga')

ExerciseReason.find_or_create_by!(name: 'Weight Loss')
ExerciseReason.find_or_create_by!(name: 'Social Support')
ExerciseReason.find_or_create_by!(name: 'Reduce Pain')
ExerciseReason.find_or_create_by!(name: 'Reduce Fatigue')
ExerciseReason.find_or_create_by!(name: 'Emotional Health')
ExerciseReason.find_or_create_by!(name: 'Physical Health')
ExerciseReason.find_or_create_by!(name: 'Sense of Accomplishment')
ExerciseReason.find_or_create_by!(name: 'Other  - Describe in About You question below')

User.create!(username:"admin", email:"test@test.com", password: 'dash123', admin: true)
u=User.create(username:"dash", email:"x@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1944-01-17"
u.profile.cancer_location="Lung"
u.profile.save!
u=User.create(username:"dash1", email:"x1@x.com", password: 'dash123')
u.profile.zipcode="20850"
u.profile.dob="1984-01-17"
u.profile.cancer_location="Lung"
u.profile.save!
u=User.create(username:"dash2", email:"x2@x.com", password: 'dash123')
u.profile.zipcode="20877"
u.profile.dob="1994-01-17"
u.profile.cancer_location="Lung"
u.profile.save!
u=User.create(username:"dash3", email:"x3@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1999-01-17"
u.profile.cancer_location="Lung"
u.profile.save!
u=User.create(username:"dash4", email:"x4@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1992-01-17"
u.profile.cancer_location="Lung"
u.profile.save!
u=User.create(username:"dash5", email:"x5@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1990-01-17"
u.profile.cancer_location="Breast"
u.profile.save!
u=User.create(username:"dash6", email:"x6@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1989-01-17"
u.profile.cancer_location="Breast"
u.profile.save!
u=User.create(username:"dash7", email:"x7@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1987-01-17"
u.profile.cancer_location="Breast"
u.profile.save!
u=User.create(username:"dash8", email:"x8@x.com", password: 'dash123')
u.profile.zipcode="20854"
u.profile.dob="1995-01-17"
u.profile.cancer_location="Breast"
u.profile.save!

