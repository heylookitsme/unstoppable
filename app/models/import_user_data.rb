require "csv"
require "rubygems"
#require "down"

class ImportUserData

  def self.read_data
    file = File.join(Rails.root, 'importdatacsv', 'user.csv')
    user_table = File.read(file)
    user_csv = CSV.parse(user_table, :headers => true)
    profile_hash = ImportProfileData.read_data
    puts profile_hash
    user_profile_hash = Hash.new
    cancer_locations = 
    ["Bladder","Brain","Breast","Bone","Cervical","Colorectal","Esophageal","Gall bladder","Gastric","Head and neck","Kidney","Lymphoma","Leukemia","Liver","Lung","Melanoma","Multiple myeloma","Ovarian","Pancreatic","Sarcoma","Thyroid","Other"]
    treatment_status_description = 
    ['Newly diagnosed', 
    'In treatment (ex: in the process of having surgery, chemo, radiation)',
    'Finished primary treatments-maybe on maintenance therapy (ex: hormone therapy)',
    '1-5 years post treatment',
    '5 years post treatment',
    'Living with metastatic disease']
    prefered_exercise_time = 
    ['Morning',
    'Mid-day',
    'Afternoon',
    'Evening']
    prefered_exercise_location = 
    ['Home', 
    'Gym',
    'Outdoors',
    'No preference',
    'Other - Describe in About You question below']
    fitness_level_descriptions =
      ['never been active',
      'used to be active but currently not active',
      'quite active',
      'a little active',
      'very active']
    personality = 
    ['Calm', 'Extroverted', 'Open to new Experiences', 'Reserved, quiet']
    work_status_descriptions = 
      ['Currently working full time',
      'Currently working part time',
      'Currently not working'
      ]
      referred_by =
      [ 'Facebook/social media',
        'News media',
        'Word of mouth',
        'Web search',
        'Event/conference/symposium',
        'Cancer support organization',
        'From my provider (physician, nurse, nutritionist)',
        'Other']

      activities = ["Walking", "Running", "Cycling", "Weight Lifting", "Aerobics", "Swimming", "Team Sports", "Yoga", "Pilates", "Gardening"]  
  
    
    user_csv.each do |row|
      begin
        user_hash = row.to_hash
        
        puts "#{user_hash["email"].inspect}"
        #if profile_hash["user"][0].to_i == user_hash["pk"].to_i
        #If the email already exists, skip importing the user
        user_email = user_hash["email"].downcase
        puts "user_email = #{user_email.inspect}"
        exist_username = User.find_for_authentication(:email => user_email)
        puts "Existing User: The following User with email #{exist_username.email.inspect} already exists" if exist_username
        next unless exist_username.blank?

        user = User.new
        user.email = user_email
        user.username = user_hash["username"]
        
        profile_hash.each do |profile|
          #puts "In LOOP"
          #puts "#{profile["user"].inspect}"
          #puts "#{user_hash["pk"].inspect}"
          if profile["user"].to_i == user_hash["pk"].to_i
=begin
            puts "MATCH!!!"
            puts profile
            puts "USER"
            puts user_hash
            puts "PROFILE"
            puts profile_hash["user"]
            puts profile_hash["user"].class
=end
            
            #puts "user = #{user.inspect}"
            p = Profile.new
            p.zipcode = profile["postal_code"]
            p.dob = profile["date_of_birth"]
            if profile["email_confirmed"] == "TRUE"
              user.email_confirmed = true
            else
              user.email_confirmed = false
            end  
            if profile["is_superuser"] == "TRUE"
              user.admin = true
            else
              user.admin = false
            end  
            p.latitude = profile["latitute"]
            p.longitude = profile["longitude"]
            p.cancer_location = cancer_locations[profile["cancer_location"].to_i]
            p.other_cancer_location = profile["cancer_type"]
            p.details_about_self = profile["self_description"]
            p.treatment_status = treatment_status_description[profile["treatment_status"].to_i]
            p.prefered_exercise_time = prefered_exercise_time[profile["time_of_exercise"].to_i]
            p.treatment_description = profile["treatment_description"]
            p.prefered_exercise_location = prefered_exercise_location[profile["location_of_exercise"].to_i]
            p.fitness_level = fitness_level_descriptions[profile["fitness_level"].to_i]
            p.personality = personality[profile["personality"].to_i]
            if profile["support_group"] == "TRUE"
              p.part_of_wellness_program = true
            else
              p.part_of_wellness_program = false
            end 
            p.which_wellness_program = profile["support_group_desc"]
            p.work_status = work_status_descriptions[profile["work_situation"].to_i]
            p.referred_by = referred_by[profile["referred_by"].to_i]
            p.other_favorite_activities = profile["activites_other"] 
            #p.activities = profile["activities"].tr('[]', '').split(',').map(&:to_i)
            unless profile["activities"].nil?
              activities = eval(profile["activities"])
              activities.each do |activity_id|
                activity_record = Activity.find_by_id(activity_id)
                p.activities << activity_record
              end 
            end
            unless profile["goals"].nil?
              exercise_reasons = eval(profile["goals"])
              exercise_reasons.each do |er_id|
                exercise_reason = ExerciseReason.find_by_id(er_id)
                p.exercise_reasons << exercise_reason
              end 
            end
            #p.exercise_reasons = profile["goals"].tr('[]', '').split(',').map(&:to_i)
            #p.save!
            p.user_id = user.id
            user.profile = p
            user.zipcode = profile["postal_code"]
            user.dob = profile["date_of_birth"]
            user.password = "password"
            begin
              if user.save!
                puts "User with email #{user.email.inspect}"
              else
                puts "Error : #{user.errors}"
                raise
              end
            rescue => ex
              puts ex.message
            end
          end
        end
        #user.profile.dob = user_hash["dob"]
        #user.password = "tars123"
        #puts "USER INFO"
        #puts user_hash
        #user.save!
      rescue => e
        # print the exception
        puts e.message
        e.backtrace.each { |line| puts line }
        next
      end
    end
    
    
  end

end
