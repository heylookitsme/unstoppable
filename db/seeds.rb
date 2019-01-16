# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Activity.create(name: 'Walking')
Activity.create(name: 'Running')
Activity.create(name: 'Cycling')
Activity.create(name: 'Weight Lifting')
Activity.create(name: 'Aerobics')
Activity.create(name: 'Pilates')
Activity.create(name: 'Gardening')
Activity.create(name: 'Team Sports')
Activity.create(name: 'Pilates')
Activity.create(name: 'Yoga')

ExerciseReason.create(name: 'Weight Loss')
ExerciseReason.create(name: 'Social Support')
ExerciseReason.create(name: 'Reduce Pain')
ExerciseReason.create(name: 'Reduce Fatigue')
ExerciseReason.create(name: 'Emotional Health')
ExerciseReason.create(name: 'Physical Health')
ExerciseReason.create(name: 'Sense of Accomplishment')
ExerciseReason.create(name: 'Other  - Describe in About You question below')
