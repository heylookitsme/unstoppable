class Profile < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, :message => "User can only have one Profile"
  validates :user_id, presence: true
  validates :dob, :presence => true
  #validate :check_fitness_level
  validate :check_reason_for_match
  validate :check_cancer_location
  validate :validate_age
  validate :check_zipcode
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :exercise_reasons
  #has_and_belongs_to_many :events
  has_many :likes 
  has_one_attached :avatar
  attribute :age
  attribute :distance, default: 0
  attribute :liked_profiles, default:[]
  attribute :active
  attribute :last_seen_at
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
  STEPS_ORDER = [STEP_BASIC_INFO, STEP_ABOUT_ME, STEP_CANCER_HISTORY, STEP_EMAIL_CONFIRMATION_SENT, STEP_CONFIRMED_EMAIL]

  MIN_AGE = 18
  MAX_AGE = 120

  #Scopes
  scope :except_self, -> (id) {where(["id != ?", id])}
  scope :confirmed, -> { where(["step_status = ?", Profile::STEP_CONFIRMED_EMAIL])}
  scope :updated_order_desc, -> {order("updated_at DESC")}
  scope :updated_order_asc, -> {order("updated_at ASC")}
  scope :newest_member_order_desc, -> {order("created_at DESC")}
  scope :newest_member_order_asc, -> {order("created_at ASC")}
  scope :favorites, -> (id) { joins(:likes).where(['likes.profile_id = ?',id ])}

  #Method used for Profile search
  include PgSearch::Model

  # Keyword1 OR Keyword2 OR Keyword3
  pg_search_scope :search_any_word, :against => [:cancer_location, :other_cancer_location, :details_about_self, :city, :zipcode, :state, :state_code],
    using: {
      :tsearch => {:prefix => true, :any_word => true}
    }

  # Keyword1 AND Keyword2 AND Keyword3
  pg_search_scope :search_all_words, :against => [:cancer_location, :other_cancer_location,     :details_about_self, :city, :zipcode, :state, :state_code],
    using: {
      :tsearch => {:prefix => true}
    }

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

  def display_username
    self.user.username
  end

  def display_email
    self.user.email
  end

=begin
  def distance
    Rails.logger.debug "DISTANCE"
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
    Rails.logger.debug "DISTANCE=#{d}"
  end
=end

  def address
    [self.city, self.state, self.country].compact.join(', ')
  end
    
  # The list of all profiles visible to the user on the "Browse Profiles" entry page
  def browse_profiles_list
    @profiles = Profile.where(["id != ? and step_status = ?", self.id, Profile::STEP_CONFIRMED_EMAIL]).order("updated_at DESC")
  end


  def self.get_list(profile_list, culat, culong)
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
        zipcode_details = ZipCodes.identify(self.zipcode)
        self[:city] = zipcode_details[:city]
        self[:state] = zipcode_details[:state_name]
        self[:state_code] = zipcode_details[:state_code]
        self[:country] = "USA"
        self[:time_zone] = zipcode_details[:time_zone]
        result = Geocoder.search(self.address)
      rescue Geocoder::OverQueryLimitError
        sleep 2
        retry
      end
      unless result.nil? || result.empty?
        Rails.logger.debug("#{result.inspect}")
        latlong = result.first.coordinates 
        self.latitude = latlong[0]
        self.longitude = latlong[1]
        # Save city
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
    computed_age = 0
    unless self.dob.nil?
      computed_age = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
    end
    computed_age
  end

  def self.cancer_locations_list
    [
      'Other/Rare Cancer',
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
    '> 5 years post treatment',
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
      'News/Media',
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

=begin 
  def check_referred_by
    unless self.step_status.blank?
      if self.step_status != STEP_BASIC_INFO &&  self.step_status != STEP_CONFIRMED_EMAIL && self.step_status != STEP_ABOUT_ME
        if self.referred_by.blank?
          errors.add(:referred_by, ', Please select one of the options in How did you learn from us')
        end
      end
    end
  end
=end

  def check_fitness_level
    unless self.step_status.blank?
      Rails.logger.debug "STEP== #{step_status.inspect}"
      if self.step_status == STEP_ABOUT_ME || self.step_status == STEP_CONFIRMED_EMAIL
        if self.fitness_level.blank?
          errors.add(:fitness_level, 'Please complete required question.')
        end
      end
    end
  end

  def check_reason_for_match
    unless self.step_status.blank?
      Rails.logger.debug "STEP== #{step_status.inspect}"
      if self.step_status == STEP_ABOUT_ME || self.step_status == STEP_CONFIRMED_EMAIL
        if self.reason_for_match.blank?
          errors.add(:reason_for_match, 'Please complete required question.')
        end
      end
    end
  end

  def check_cancer_location
    unless self.step_status.blank?
      Rails.logger.debug "check_cancer_location STEP== #{step_status.inspect}"
      if self.step_status == STEP_CANCER_HISTORY || self.step_status == STEP_CONFIRMED_EMAIL
        if self.cancer_location.blank?
          errors.add(:cancer_location, 'Please select one of the options for your primary cancer diagnosis')
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
