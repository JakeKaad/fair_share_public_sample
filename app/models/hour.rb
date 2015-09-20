class Hour < ActiveRecord::Base
  belongs_to :member
  belongs_to :subactivity
  belongs_to :submitted_by, class_name: "Member"
  delegate :name, to: :subactivity
  delegate :family, to: :member

  validates_date :date_earned, on_or_before: lambda { Time.current.to_date }
  validates :date_earned, presence: true
  validates :member_id, presence: true
  validates :subactivity_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 500 }
  validate  :date_in_current_year

  default_scope { order 'date_earned DESC' }
  def date_in_current_year
    unless earned_in_school_year?
      errors.add(:date_earned, "must be between July 1 and today.")
    end
  end

  def formatted_date_earned
    date_earned.strftime("%m/%d/%Y")
  end

  def self.set_registration_hour(user)
    unless user.family.has_registration_hour?
      subactivity = Subactivity.where(name: "Create Account").first
      user.hours.create(subactivity_id: subactivity.id, quantity: 1, date_earned: Time.now, submitted_by_id: user.member.id)
    end
  end

  def submitted_by
    begin
      Member.find(submitted_by_id)
    rescue ActiveRecord::RecordNotFound => invalid
      Member.new(first_name: "FMES", last_name: "Admin")
    end
  end

  private

  def earned_in_school_year?
    beginning_date = Time.zone.local(2015, 7, 1)
    end_date = Time.zone.local(2016, 6, 30)
    date_earned.present? && date_earned >= beginning_date && date_earned <= end_date
  end
end
