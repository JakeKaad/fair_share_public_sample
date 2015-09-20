class Category < ActiveRecord::Base
  include Archive
  has_many :activities, ->  { order :name }

  default_scope { order :name }

  validates :name, presence: true, uniqueness: true

  def archive_category
    toggle_archived
    activities.each do |activity|
      activity.toggle_archived
      activity.archive_subactivities
    end
  end
end
