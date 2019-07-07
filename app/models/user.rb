class User < ApplicationRecord
  has_one :profile, :dependent => :destroy
  validates :username, presence: :true, uniqueness: { case_sensitive: false } #, message: "Please enter the Username"
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :dob_minimum
  #validates :zipcode, presence: :true
  validate :check_zipcode
  #validates_zipcode :zipcode
  #validates :zipcode, zipcode: { country_code: :us }
  validates :zipcode, zipcode: true

  acts_as_messageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_writer :login

  attr_accessor :zipcode
  attr_accessor :country_alpha2

  attr_accessor :unread_messages

  attribute :dob, :date

  after_create :init_profile

  before_create :confirmation_token

  before_validation :set_country_alpha2

  def unread_messages
    self.mailbox.inbox(:unread => true).count
  end

  def set_country_alpha2
    country_iso = ISO3166::Country.find_country_by_name("united states")
    self.country_alpha2 = country_iso.alpha2.downcase
  end

  def self.current
    RequestStore.store[:current_user]
  end

  def self.current=(user)
    RequestStore.store[:current_user] = user
  end

  def init_profile
    self.create_profile
    self.profile.zipcode = self.zipcode
    #Rails.logger.debug "User DOB = #{self.dob.inspect}"
    self.profile.dob = self.dob
    self.profile.step_status = "Basic Info"
    self.profile.moderated = true
    self.profile.save!
  end


  def login
    @login || self.username || self.email
  end

  def confirmation_required?
    false
  end

  def email_activate
    Rails.logger.debug "IN EMAIL_ACTOV=begin TE =end"
    self.email_confirmed = true
    self.confirm_token = nil
    self.save!(:validate => false)
  end

  def name
    self.username
  end

  def mailboxer_email(object)
    nil
  end

  private
  def confirmation_token
        if self.confirm_token.blank?
            self.confirm_token = SecureRandom.urlsafe_base64.to_s
        end
  end
  
  def dob_minimum
    age = 0
    if dob.blank?
      errors.add(:dob, 'Please Add your Date of Birth')
    else
      #Rails.logger.debug "Before dob = #{dob.inspect}"
      age = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
      #Rails.logger.debug "after age = #{age.inspect}"
    end
    if age < 18
      errors.add(:age, 'You should be over 18 years old.')
    end
  end

  def check_zipcode
    zipcode_details = ZipCodes.identify(self.zipcode)
    if zipcode_details.nil?
      errors.add(:zipcode, 'This is not a valid US zipcode')
    end
  end

end
