class Subactivity < ActiveRecord::Base
  include Archive
  belongs_to :activity
  has_many :hours

  default_scope { order :name }

  validates :name, presence: true
end
