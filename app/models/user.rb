class User < ApplicationRecord
  has_one :profile, :dependent => :destroy
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :check_zipcode,  :if => :no_password_change
  validates :zipcode, presence: :true,  :if => :no_password_change
  validate :check_referred_by, :if => :no_password_change
  validates :dob, presence: :true, :if => :no_password_change
  validate :dob_minimum, :if => :no_password_change
  validate :check_username, :if => :no_password_change

  attr_accessor :terms_of_service
  #validates_acceptance_of :terms_of_service, on: :create
  validate :check_terms
  #validates :terms_of_service, :acceptance => {:accept => true} , on: :create, allow_nil: false

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

  attribute :referred_by

  after_create :init_profile

  before_create :confirmation_token

  before_validation :set_country_alpha2

  def no_password_change
    !encrypted_password_changed?
  end

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
    self.profile.dob = self.dob
    self.profile.step_status = Profile::STEP_BASIC_INFO
    self.profile.referred_by = self.referred_by
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
      #Rails.logger.debug "Before dob = #{dob.inspect}"
      unless self.dob.nil?
        age = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
        #Rails.logger.debug "after age = #{age.inspect}"
        if age < 18
          errors.add(:dob, 'You should be over 18 years old.')
        end
      end
  end

  def check_zipcode
    zipcode_details = ZipCodes.identify(self.zipcode)
    unless zipcode_details.blank?
      errors.add(:zip_code, 'Please enter a valid US Zip Code')
    end
  end

  def check_referred_by
    if referred_by.blank?
      errors.add(:referred_by, 'Please select a value')
    end
  end

  def check_username
    unless username.blank?
     if username.include?("@")
      errors.add(:username, 'Username cannot be an email address.')
     end
    end
  end

  def check_terms
    Rails.logger.debug("XXX terms of service = #{self.terms_of_service}")
    Rails.logger.debug("XXX terms of service = #{self.persisted?}")
    Rails.logger.debug("XXX errors = #{errors.inspect}")
    unless self.persisted?
      if self.terms_of_service == "0"
        Rails.logger.debug("ADDING ERROR")
        errors.add(:terms_of_service, 'Please accept terms of service')
      end
    end
  end

end
