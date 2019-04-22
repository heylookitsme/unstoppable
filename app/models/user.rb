class User < ApplicationRecord
  has_one :profile, :dependent => :destroy
  validates :username, presence: :true, uniqueness: { case_sensitive: false } #, message: "Please enter the Username"
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :dob_minimum
  validates :zipcode, presence: :true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_writer :login

  attr_accessor :zipcode
  attribute :dob, :date

  after_create :init_profile

  before_create :confirmation_token

  

  def self.current
    RequestStore.store[:current_user]
  end

  def self.current=(user)
    RequestStore.store[:current_user] = user
  end

  def init_profile
    self.create_profile
    self.profile.zipcode = self.zipcode
    Rails.logger.debug "User DOB = #{self.dob.inspect}"
    self.profile.dob = self.dob
    self.profile.step_status = "Basic Info"
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

  private
  def confirmation_token
        if self.confirm_token.blank?
            self.confirm_token = SecureRandom.urlsafe_base64.to_s
        end
  end
  
  def dob_minimum
    if dob.blank?
      errors.add(:dob, 'Please Add your Date of Birth')
    else
      x = ((Time.zone.now - self.dob.to_time) / 1.year.seconds).floor
    end
    if x < 18
        errors.add(:dob, 'You should be over 18 years old.')
    end
  end
end
