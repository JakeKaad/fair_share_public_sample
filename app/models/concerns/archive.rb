module Archive
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(archived: false) }
    scope :archived, -> { where(archived: true) }
    after_create :set_archived
  end

  def toggle_archived
    self.archived = !self.archived
    self.save
  end

  def set_archived
    self.archived = false
    self.save
  end
end
