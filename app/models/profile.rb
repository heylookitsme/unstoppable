class Profile < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, :message => "User can only have one Profile"
  validates :user_id, presence: true
  validates :dob, :presence => true
  validate :check_fitness_level
  validate :check_referred_by
  validate :validate_age
  validate :check_zipcode
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :exercise_reasons
  has_many :likes 
  has_one_attached :avatar
  attribute :age
  attribute :distance, default: 0
  # Attribute for determining if approved email needs to be sent
  attribute :send_approved_email, :default => false
  geocoded_by :address
  after_validation :geocode, :if => :zipcode_changed?
  before_save :compute_latlong

  #constants
  STEP_BASIC_INFO = "Basic Info"
  STEP_ABOUT_ME = "About Me"
  STEP_CANCER_HISTORY = "Cancer History"
  STEP_CONFIRMED_EMAIL = "Confirmed Email"
  STEP_EMAIL_CONFIRMATION_SENT = "Email Confirmation Sent"
  STEP_PHOTO_ATTACHED_WIZARD = "Photo Attached Wizard"
  STEP_PHOTO_ATTACHED = "Photo Attached"

=begin
# TEMPORARILY DISABLING SEARCHES
  searchable do
    text :details_about_self
    text :other_cancer_location
    text :cancer_location
    integer :age 
    integer :distance
    text :zipcode
    text :activities do
      activities.map { |activity| activity.name }
    end
    
    #latlon(:zipcode) { Sunspot::Util::Coordinates.new(:latitude, :longitude) }
  end
=end

  def email_confirmed?
    self.step_status == STEP_CONFIRMED_EMAIL
  end

  def address
    self.zipcode
  end

  def distance
    d=0
    unless self.user.admin?
      if !User.current.blank? && !User.current.profile.blank?
        if !User.current.profile.latitude.blank? && !User.current.profile.latitude.blank? 
          d = self.distance_to([User.current.profile.latitude, User.current.profile.longitude])
          unless d.blank?
            d = d.round
          end
        end
      end
    end
    d
  end

  def self.get_list(profile_list, culat, culong)
    #Rails.logger.debug "in Profile get_list CURRENT = #{User.current.inspect}"
    all_profiles = []
    for profile in profile_list do
      #unless profile.user.admin?
        Rails.logger.debug "#{culat}.inspect"
        if !culat.nil? && !culong.nil? && !profile.latitude.nil? && !profile.longitude.nil?
          profile.distance = profile.distance_to([culat, culong]).round
        end
        all_profiles << profile
      #end
    end
    all_profiles
  end

  def compute_latlong
    Rails.logger.debug "IN COMPUTE_LATLONG"
    unless self.zipcode.nil?
      begin
        result = Geocoder.search(self.zipcode)
      rescue Geocoder::OverQueryLimitError
        sleep 2
        retry
      end
      unless result.nil? || result.empty?
        Rails.logger.debug("#{result.inspect}")
        latlong = result.first.coordinates 
        self.latitude = latlong[0]
        self.longitude = latlong[1]
      end
    end
  end

=begin  
  def set_age
    age = 0
    unless self.dob.nil?
      age = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
    end
    self.age = age
  end

  
=end  

  def age
    x = 0
    unless self.dob.nil?
      x = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
    end
    x.to_s
    #self.age = age
  end

  def self.cancer_locations_list
    [
      'Any Location',
      'Bladder',
      'Brain',
      'Breast',
      'Bone',
      'Cervical',
      'Colorectal',
      'Esophageal',
      'Gall Bladder',
      'Gastric',
      'Head and Neck',
      'Kidney',
      'Lymphoma',
      'Leukemia',
      'Liver',
      'Lung',
      'Melanoma',
      'Multiple Myeloma',
      'Ovarian',
      'Pancreatic',
      'Sarcoma',
      'Thyroid'
    ]
  end

  def self.personality_descriptions
    ['Calm', 'Extroverted', 'Open to new Experiences', 'Reserved, quiet']
  end

  def self.treatment_status_descriptions
    ['Newly diagnosed', 
    'In treatment (ex: in the process of having surgery, chemo, radiation)',
    'Finished primary treatments-maybe on maintenance therapy (ex: hormone therapy)',
    '1-5 years post treatment',
    '5 years post treatment',
    'Living with metastatic disease'
    ]
  end

  def self.prefered_exercise_location_descriptions
    ['Home', 
    'Gym',
    'Outdoors',
    'No preference',
    'Other - Describe in About You question below'
    ]
  end

  def self.prefered_exercise_time_descriptions
    ['Morning',
    'Mid-day',
    'Afternoon',
    'Evening'
    ]
  end

  def self.fitness_level_descriptions
    ['never been active',
    'used to be active but currently not active',
    'quite active',
    'a little active',
    'very active'
    ]
  end

  def self.work_status_descriptions
    ['Currently working full time',
    'Currently working part time',
    'Currently not working'
    ]
  end

  def self.referred_by
    [ 'Facebook/social media',
      'News media',
      'Word of mouth',
      'Web search',
      'Event/conference/symposium',
      'Cancer support organization',
      'From my provider (physician, nurse, nutritionist)',
      'Other'
    ]
  end

  def validate_age
    if age.to_i < 18
        errors.add(:dob, 'You should be over 18 years old.')
    end
  end

  def check_referred_by
    unless self.step_status.blank?
      if self.step_status != STEP_BASIC_INFO &&  self.step_status != STEP_CONFIRMED_EMAIL && self.step_status != STEP_ABOUT_ME
        if self.referred_by.blank?
          errors.add(:referred_by, ', Please select one of the options in How did you learn from us')
        end
      end
    end
  end

  def check_fitness_level
    unless self.step_status.blank?
      if self.step_status != STEP_BASIC_INFO &&  self.step_status != STEP_CONFIRMED_EMAIL && self.step_status != STEP_CANCER_HISTORY
        if self.fitness_level.blank?
          errors.add(:fitness_level, ', Please select one of the options in How did you learn from us')
        end
      end
    end
  end

  def check_liked(check_profile_id)
    profile_liked = false
    if self.likes.exists?(like_id: check_profile_id)
      profile_liked = true
    end
    return profile_liked
  end

  def profile_exists(profiles)
    all_profile_ids = profiles.collect{|x| x.id}
    e = all_profile_ids.include?(self.id)
    Rails.logger.debug("EXISTS = {e.inspect}")
    e
  end

  def check_zipcode
    zipcode_details = ZipCodes.identify(self.zipcode)
    if zipcode_details.nil?
      errors.add(:zipcode, 'This is not a valid US zipcode')
    end
  end
  #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => #"/images/:style/missing.png"
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
