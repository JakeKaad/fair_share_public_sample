class Member < ActiveRecord::Base
  include Archive

  belongs_to :family
  has_many :students, through: :family
  has_one :user
  has_and_belongs_to_many :activities
  has_many :hours
  has_many :submitted_bys, through: :hours

  validates :first_name, presence: true
  validates :last_name, presence: true
  default_scope { order "last_name" }

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.RELATIONSHIPS
    ["Parent","Grandparent","Sibling","Other Relative","Family Friend"]
  end
end
