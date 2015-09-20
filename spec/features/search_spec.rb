require 'rails_helper'

describe 'admin searches through families', js: true do
  it 'should populate the families with search results' do
    family_one = FactoryGirl.create(:family, name: "The Does")
    family_two = FactoryGirl.create(:family, name: "The Dahmers")
    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit families_path
    search_input = page.find("#family_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "The Does"
    expect(page).to have_content "The Dahmers"

    search_input.native.send_keys "o"
    expect(page).to have_content "The Does"
    expect(page).to_not have_content "The Dahmers"
  end

  it 'should populate the families with archived search results on archived tab' do
    family_one = FactoryGirl.create(:family, name: "The Does")
    family_two = FactoryGirl.create(:family, name: "The Dahmers")
    family_one.toggle_archived
    family_two.toggle_archived

    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit families_path(tab: "archived")
    search_input = page.find("#family_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "The Does"
    expect(page).to have_content "The Dahmers"

    search_input.native.send_keys "o"
    expect(page).to have_content "The Does"
    expect(page).to_not have_content "The Dahmers"
  end
end

describe 'admin searches through students', js: true do
  it 'should populate the families with search results' do
    student_one = FactoryGirl.create(:student, first_name: "John", last_name: "Doe")
    student_two = FactoryGirl.create(:student, first_name: "Jeff", last_name: "Dahmer")
    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit students_path
    search_input = page.find("#student_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "John Doe"
    expect(page).to have_content "Jeff Dahmer"

    search_input.native.send_keys "o"
    expect(page).to have_content "John Doe"
    expect(page).to_not have_content "Jeff Dahmer"
  end

  it 'should populate the families with archived search results on archived tab' do
    student_one = FactoryGirl.create(:student, first_name: "John", last_name: "Doe")
    student_two = FactoryGirl.create(:student, first_name: "Jeff", last_name: "Dahmer")
    student_one.toggle_archived
    student_two.toggle_archived

    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit students_path(tab: "archived")
    search_input = page.find("#student_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "John Doe"
    expect(page).to have_content "Jeff Dahmer"

    search_input.native.send_keys "o"
    expect(page).to have_content "John Doe"
    expect(page).to_not have_content "Jeff Dahmer"
  end
end

describe 'admin searches through members', js: true do
  it 'should populate the families with search results' do
    member_one = FactoryGirl.create(:member, first_name: "John", last_name: "Doe")
    member_two = FactoryGirl.create(:member, first_name: "Jeff", last_name: "Dahmer")
    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit members_path
    search_input = page.find("#member_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "John Doe"
    expect(page).to have_content "Jeff Dahmer"

    search_input.native.send_keys "o"
    expect(page).to have_content "John Doe"
    expect(page).to_not have_content "Jeff Dahmer"
  end

  it 'should populate the families with archived search results on archived tab' do
    member_one = FactoryGirl.create(:member, first_name: "John", last_name: "Doe")
    member_two = FactoryGirl.create(:member, first_name: "Jeff", last_name: "Dahmer")
    member_one.toggle_archived
    member_two.toggle_archived

    admin = FactoryGirl.create(:admin)
    login_as(admin, scope: :admin)

    visit members_path(tab: "archived")
    search_input = page.find("#member_search")

    search_input.native.send_keys "d"
    expect(page).to have_content "John Doe"
    expect(page).to have_content "Jeff Dahmer"

    search_input.native.send_keys "o"
    expect(page).to have_content "John Doe"
    expect(page).to_not have_content "Jeff Dahmer"
  end
end


