class Profile < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, :message => "User can only have one Profile"
  validates :user_id, presence: true
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :exercise_reasons
  has_one_attached :avatar
  #attr_accessor :age
  attribute :age
  attr_accessor :junk

=begin
  acts_as_mappable :default_units => :miles,
                   
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
=end

  #validates :zipcode, presence: true
  geocoded_by :get_address
  #after_validation :geocode
  after_validation :geocode, :if => :zipcode_changed?
  before_save :compute_latlong
  #before_save :set_age

  def initialize
    self.age = self.set_age
  end
  
  
  searchable do
    text :details_about_self
    text :other_cancer_location
    text :cancer_location
    integer :age
    text :activities do
      activities.map { |activity| activity.name }
    end
    
    #latlon(:zipcode) { Sunspot::Util::Coordinates.new(:latitude, :longitude) }
  end

  def get_address
    self.zipcode
  end

  def self.get_list
    all_profiles = []
    for profile in Profile.all do
      unless profile.user.admin?
        #profile.age = profile.set_age
        puts "HI #{profile.age}"
        all_profiles << profile
      end
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

  #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => #"/images/:style/missing.png"
  #validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
