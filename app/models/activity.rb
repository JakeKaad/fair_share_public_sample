class Activity < ActiveRecord::Base
  include Archive

  has_and_belongs_to_many :members
  belongs_to :category
  has_many :subactivities, ->  { order :name }

  default_scope { order :name }

  validates :name, presence: true, uniqueness: true

  def archive_subactivities
    subactivities.map(&:toggle_archived)
  end

  def archive_activity
    toggle_archived
    archive_subactivities
  end
  # Category.all.each do |category|
  #   scope category.name.gsub(" ","").downcase, -> { where(category_id: category.id)}
  # end
end
