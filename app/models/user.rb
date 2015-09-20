class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :registerable to prevent user sign ups (invite only!) - kb
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :member
  validates :email, uniqueness: true
  validates :member, presence: true
  delegate :first_name, to: :member
  delegate :last_name, to: :member
  delegate :family, to: :member
  delegate :hours, to: :member

  def self.create_unregistered_user(member, rake=nil)
    password = create_token
    user = User.create(email: member.email, password: password, registration_token: User.create_token, member_id: member.id) if member.email
    FairShareMailer.delay.send_welcome_email(user.id) unless rake
    user
  end

  def registered?
    registration_token.empty?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def self.create_token
    SecureRandom.urlsafe_base64
  end
end
