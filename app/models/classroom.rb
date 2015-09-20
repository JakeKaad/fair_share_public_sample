class Classroom < ActiveRecord::Base
  has_many :students
  default_scope { order "name" }
  validates :name, presence: true, uniqueness: true

  def self.CLASSROOMS
    [
      ["Alder","Lower Elementary"],
      ["Pine", "Lower Elementary"],
      ["Spruce", "Lower Elementary"],
      ["Hawthorn", "Lower Elementary"],
      ["Redwood", "Children's House"],
      ["Juniper", "Children's House"],
      ["Larch", "Children's House"],
      ["Fir", "Children's House"],
      ["Walnut", "Upper Elementary"],
      ["Maple", "Upper Elementary"],
      ["Willow", "Upper Elementary"],
      ["Saint Francis Academy", "SFA"]
    ]
  end
end
