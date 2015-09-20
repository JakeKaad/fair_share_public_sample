require 'rails_helper'

describe 'adding new subactivities' do
  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let!(:category) { FactoryGirl.create(:category) }
    let!(:activity) { FactoryGirl.create(:activity, category_id: category.id) }
    before { login_as(admin, scope: :admin) }

     it 'should add a new activtiy', js: true do
      go_home
      click_link 'Control Panel'
      click_link 'Categories'
      click_link category.name
      click_on activity.name
      click_on 'Add subactivity'
      fill_in 'Name', with: "Subactivity Name"
      fill_in 'Assigned hours', with: '1'
      click_on 'Create Subactivity'
      expect(page).to have_content "Subactivity Name"
    end

    it 'should let an admin delete a category' do
      subactivity = FactoryGirl.create(:subactivity, activity_id: activity.id)
      visit activity_path(activity)
      click_on "delete-subactivity-#{subactivity.id}"
      expect(page).to_not have_content subactivity.name
    end

    it 'should let an admin edit a category' do
      subactivity = FactoryGirl.create(:subactivity, activity_id: activity.id)
      visit activity_path(activity)
      click_on "edit-subactivity-#{subactivity.id}"
      fill_in "Name", with: "New Name"
      click_on "Update Subactivity"
      expect(page).to have_content "New Name"
    end
  end
end
