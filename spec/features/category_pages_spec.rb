require 'rails_helper'

describe 'interacting with categories' do
  context 'not as admin' do
    let(:action) { visit categories_path }
    it_behaves_like 'integration require admin'
  end

  context 'as an admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before { login_as(admin, scope: :admin) }

    it 'should add a new category' do
      go_home
      click_link 'Control Panel'
      click_link 'Categories'
      fill_in 'Name', with: 'Sample category'
      click_on 'Create Category'
      expect(page).to have_content 'Sample category'
    end

    it 'should let an admin delete a category' do
      category = FactoryGirl.create(:category)
      visit category_path(category)
      click_on "Delete"
      visit categories_path
      expect(page).to_not have_content category.name
    end

    it 'should let an admin edit a category' do
      category = FactoryGirl.create(:category)
      visit category_path(category)
      click_on "edit-category"
      fill_in "Name", with: "New Name"
      expect(page).to_not have_content "New Name"
    end
  end
end


