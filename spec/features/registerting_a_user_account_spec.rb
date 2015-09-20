require 'rails_helper'

describe 'creating a new user account' do
  let(:alice) { FactoryGirl.create(:user, registration_token: "abc123") }
  before { create_registration_activity }

  it 'should be able to register an account' do
    visit register_with_token_path registration_token: alice.registration_token
    fill_in 'Password', with: "new_password"
    fill_in 'Password confirmation', with: "new_password"
    click_on 'Update User'
    expect(page).to have_content "Registered successfully"
    expect(alice.reload.registration_token).to eq ""
  end

  it "shouldnt update a user when token is expired" do
    visit register_with_token_path registration_token: "123456"
    expect(page).to have_content "expired"
  end

  it "should create a registration hour if the family doesnt have a registartion hour" do
    visit register_with_token_path registration_token: alice.registration_token
    fill_in 'Password', with: "new_password"
    fill_in 'Password confirmation', with: "new_password"
    click_on 'Update User'
    sign_in_user(alice)
    visit family_hours_path alice.family.reload
    expect(page).to have_content "1.0 shared"
  end

  it "shouldn't create a registration hour if the family has a registration hour" do
    visit register_with_token_path registration_token: alice.registration_token
    alice.hours.create(quantity: 1, subactivity_id: Subactivity.first.id)
    fill_in 'Password', with: "new_password"
    fill_in 'Password confirmation', with: "new_password"
    click_on 'Update User'
    sign_in_user(alice)
    alice.registration_token = "abc123"
    visit family_hours_path alice.family.reload
    expect(page).to have_content "1.0 shared"
  end
end
