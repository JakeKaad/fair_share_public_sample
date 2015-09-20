FactoryGirl.define do
  factory :student do
    sequence(:first_name) { |n| "John #{n}" }
    last_name "Doe"
    grade Student.GRADES[0]
    enrolled true
    classroom_id 1
    family
    archived false
  end

  factory :classroom do
    sequence(:name) { |n| "#{n} grade" }
    level "Lower Elementary"
  end

  factory :admin do
    sequence(:email) { |n| "admin#{n}@test.com" }
    password "password"
    password_confirmation "password"
  end

  factory :family do
    sequence(:name) { |n| "Family #{n}" }
    archived false
  end

  factory :member do
    sequence(:first_name) { |n| "Lucy #{n}" }
    last_name "Lawless"
    relationship_to_student "Parent"
    sequence(:email) { |n| "xena#{n}@warriorprincess.com" }
    phone "555-555-5555"
    family
    archived false
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password "password"
    password_confirmation "password"
    registration_token ""
    member
  end

  factory :category do
    sequence(:name) { |n| "Test Category #{n}" }
    archived false
  end

  factory :activity do
    sequence(:name) { |n| "Test Activity #{n}" }
    category
    archived false
  end

  factory :subactivity do
    sequence(:name) { |n| "Test subactivity #{n}" }
    activity
    archived false
  end

  factory :hour do
    quantity 1
    subactivity
    member
    date_earned Time.now
    submitted_by_id FactoryGirl.create(:member).id
  end
end
