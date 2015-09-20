class Student < ActiveRecord::Base
  include Archive

  belongs_to :family
  belongs_to :classroom
  has_many :members, through: :family
  has_and_belongs_to_many :school_years
  validates :first_name, presence: true
  validates :last_name, presence: true
  default_scope { order "last_name" }
  after_create :set_archived

  def self.GRADES
    ["2YO", "3YO", "4YO", "5YO", "6YO", "First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth"]
  end

  def self.parse_student_names(family_name)
    names = []
    family_name.split(" and ").each do |name|
      if name.include?(",")
        name.split(", ").each do |new_name|
          names.push new_name.strip
        end
      else
        names.push name.strip
      end
    end
    names
  end

  def full_name
    first_name + " " + last_name
  end
end
