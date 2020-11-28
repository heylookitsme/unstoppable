class User < ApplicationRecord
  has_one :profile, :dependent => :destroy
  has_one :phone, :dependent => :destroy
  attr_accessor :terms_of_service
  #validates_acceptance_of :terms_of_service, on: :create, :allow_nil => false, :if => :no_password_change
  #validate :check_terms, :if => :no_password_change
  #validates_acceptance_of :check_terms, :allow_nil => false, :if => :no_password_change
  #validates :terms_of_service, :acceptance => {:accept => true} , on: :create, allow_nil: false
  serialize :search_params

  acts_as_messageable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_writer :login

  attr_accessor :zipcode
  attr_accessor :country_alpha2

  attr_accessor :unread_messages

  attr_accessor :phone_number

  attribute :dob, :date

  attribute :referred_by

  after_create :init_profile

  after_create :save_phone

  before_create :confirmation_token

  before_validation :set_country_alpha2

  validates :username, presence: {:message => "", :hint => "abcdef" }, uniqueness: { case_sensitive: false }
  validate :password_complexity
  validates :email, presence: {:message => "" }, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true, :message => "Please enter a valid Username", :unless => Proc.new { |a| a.username.include?("@") }
  validate :check_zipcode, :if => :no_password_change
  validate :check_referred_by, :if => :no_password_change
  validates :dob, presence: {:message => "Please enter Date of Birth", :hint => "abcdef" }, :if => :no_password_change
  validate :dob_minimum, :if => :no_password_change
  validate :check_username, :if => :no_password_change
  #validate :phone, :if => :no_password_change
  scope :last_seen, -> {where("last_seen_at > ?", 5.minutes.ago)}

  def display_step_status
    self.profile.blank? ? "" : self.profile.step_status
  end

  # When the change password screen is used, we want to bypass the validations
  def no_password_change
    status = true
    if self.persisted?
      status = !encrypted_password_changed?
    end
    status
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

  def save_phone
    p = Phone.new
    p.phone_number = self.phone_number
    self.phone = p
    self.phone.save!
  end

  def login
    @login || self.username || self.email
  end

  def confirmation_required?
    false
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    self.save!(:validate => false)
  end

  def name
    self.username
  end

  # Used by Mailboxer
  def mailboxer_email(object)
    self.email
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
        #self.confirm_token = SecureRandom.urlsafe_base64.to_s
        self.confirm_token = SecureRandom.random_number(10000)
    end
  end
  
  def dob_minimum
      age = 0
      unless self.dob.nil?
        age = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
        if age < 18
          errors.add(:dob, 'Must be 18 or older to create an account.')
        end
      end
  end

  def check_zipcode
    if self.zipcode.blank?
      errors.add(:zipcode, 'Please enter Zipcode')
      return
    end
    zipcode_details = ZipCodes.identify(self.zipcode)
    if zipcode_details.blank?
      errors.add(:zipcode, 'Please enter a valid US Zip Code')
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
    unless self.persisted?
      if self.terms_of_service == "0"
        errors.add(:terms_of_service, 'Please agree to the Terms of Use')
      end
    end
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    #return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])/

    #errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    # Your password must be at least 8 characters, contain one uppercase letter, one lowercase letter, and one number.
    errors.add :password, 'Your password must have one uppercase letter, one lowercase, and one number.'
  end

end
