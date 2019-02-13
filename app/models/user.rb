class User < ApplicationRecord
  has_one :profile, :dependent => :destroy
  before_create :create_profile


  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  attr_writer :login

  def login
    @login || self.username || self.email
  end
    
  def create_profile

    profile = build_profile(:fitness_level => "",
     :cancer_location => "",
     :treatment_status => "",
     :treatment_description => "",
     :personality => "",
     :prefered_exercise_location => "",
     :prefered_exercise_time => ""
     )
    puts profile
  end

  def confirmation_required?
    false
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
