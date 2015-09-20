require 'rails_helper'

describe "user interacting with interests on member page" do
   let(:lulu) { FactoryGirl.create(:user) }
   let(:activity) { FactoryGirl.create(:activity) }
   let!(:subactivity) { FactoryGirl.create(:subactivity, activity_id: activity.id) }
   let(:member) { lulu.member }
   before { login_as(lulu, scope: :user) }

  it "should add a new hour row", js: true  do
    visit family_hours_path(member.family)
    select activity.name, from: 'activity'
    select subactivity.name, from: 'hour_subactivity_id'
    fill_in "hour_quantity", with: 4
    fill_in "hour_date_earned", with: "2015-09-09"
    click_button 'Add hours'
    expect(page).to have_content 'Thank you for contributing your time to our community'
  end

  it "should let a member edit an hour", js: true do
    visit family_hours_path(member.family)
    select activity.name, from: 'activity'
    select subactivity.name, from: 'hour_subactivity_id'
    fill_in "hour_quantity", with: 4
    fill_in "hour_date_earned", with: "2015-09-09"
    click_button 'Add hours'
    click_on 'Edit'
    fill_in "hour_quantity", with: 3
    click_on "Update hours"
    expect(page).to have_content 'Hour updated'
    expect(page).to have_content '3'
  end
end
