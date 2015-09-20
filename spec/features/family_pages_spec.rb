require 'rails_helper'

describe 'adding family with students and members' do
  context 'not as admin' do
    let(:action) { visit new_family_path }
    it_behaves_like 'integration require login'
    it_behaves_like 'integration require admin'
  end

  context 'as an admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login_as(admin, scope: :admin) }

    it 'should add a new family' do
      go_home
      click_link 'Control Panel'
      click_link 'Add family'
      fill_in 'Name', with: 'The Does'
      click_on 'Create Family'
      expect(page).to have_content 'The Does'
    end

    it 'should add new family members', js: true do
      family = FactoryGirl.create(:family)
      visit family_path(family)
      click_on 'Add Family Member'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Doe'
      select 'Parent', from: 'Relationship to student'
      fill_in 'Email', with: 'John@Doe.com'
      fill_in 'Phone', with: '555-555-5555'
      click_on 'Create Member'
      expect(page).to have_content 'John Doe'
    end

    it 'should add new students', js: true do
      family = FactoryGirl.create(:family)
      classroom = FactoryGirl.create(:classroom)
      visit family_path(family)
      click_on 'Add Student'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Doe'
      click_on 'Create Student'
      expect(page).to have_content 'John Doe'
    end
  end
end

describe "interacting with families on the index page" do
  context "not as admin" #add these after we have a user home page

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login_as(admin, scope: :admin) }

    it "archives a family from the index page" do
      family = FactoryGirl.create(:family)
      visit admin_path(admin)
      click_on "View families"
      click_on "Archive"
      expect(page).to_not have_content family.name
    end

    it "can unarchive families" do
      family = FactoryGirl.create(:family)
      family.toggle_archived
      visit families_path
      click_on "Archived"
      click_on "Unarchive"
      expect(page).to_not have_content family.name
    end

    it "can view all families" do
      family = FactoryGirl.create(:family)
      family_two = FactoryGirl.create(:family)
      family.toggle_archived
      visit families_path
      click_on "All"
      expect(page).to have_content family.name
      expect(page).to have_content family_two.name
    end
  end
end
