class Family < ActiveRecord::Base
  include Archive

  has_many :students
  has_many :members
  has_many :hours, through: :members

  validates :name, presence: true, uniqueness: true

  default_scope { order "name" }

  def archive_family
    toggle_archived
    members.each { |member| member.toggle_archived }
    students.each { |student| student.toggle_archived }
  end

  def has_registration_hour?
    hours.map(&:name).include? "Create Account"
  end
end
