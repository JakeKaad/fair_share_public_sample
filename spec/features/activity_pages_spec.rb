require 'rails_helper'

describe 'adding new activities' do
  context 'not as admin' do
    let(:action) { visit activities_path }
    it_behaves_like 'integration require admin'
  end

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    let!(:category) { FactoryGirl.create(:category) }
    before { login_as(admin, scope: :admin) }

     it 'should add a new activtiy' do
      go_home
      click_link 'Control Panel'
      click_link 'Categories'
      click_link category.name
      click_on 'Add activity'
      fill_in 'Name', with: "Activity Name"
      click_on 'Create Activity'
      expect(page).to have_content "Activity Name"
    end

    it 'should add a new activtiy' do
      go_home
      click_link 'Control Panel'
      click_link 'Add Activities'
      click_on 'Add Activity'
      fill_in 'Name', with: "Activity Name"
      click_on 'Create Activity'
      expect(page).to have_content "Activity Name"
    end

    it 'should let an admin delete a category' do
      activity = FactoryGirl.create(:activity, category_id: category.id)
      visit category_path(category)
      click_on activity.name
      click_on "delete-activity"
      expect(page).to_not have_content activity.name
    end

    it 'should let an admin edit a category' do
      activity = FactoryGirl.create(:activity, category_id: category.id)
      visit category_path(category)
      click_on activity.name
      click_on "edit-activity"
      fill_in "Name", with: "New Name"
      click_on "Update Activity"
      expect(page).to have_content "New Name"
    end
  end
end
