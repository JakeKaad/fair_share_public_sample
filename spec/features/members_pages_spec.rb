require 'rails_helper'

describe "editing a member" do
  context "as an admin" do
    let!(:member) { FactoryGirl.create(:member) }

    it "should let an admin navigate to the form" do
      sign_in_admin
      visit members_path
      click_on "Edit"
      expect(page).to have_content "Edit"
    end

    it "lets an admin update a member with valid input" do
      sign_in_admin
      member.user = FactoryGirl.create(:user)
      visit edit_member_path(member)
      fill_in "First name", with: "Donahue"
      click_on "Update Member"
      expect(page).to have_content "Donahue"
    end

    it "doesn't update a member with invalid input" do
      sign_in_admin
      visit edit_member_path(member)
      fill_in "First name", with: ""
      click_on "Update Member"
      expect(page).to have_content "Something"
    end
  end

  context 'not as admin' do
    let(:member) { FactoryGirl.create(:member) }
    let(:action) { visit edit_member_path(member) }

    it_behaves_like 'integration require login'

    it "doesn't let users edit another user's member" do
      user = FactoryGirl.create(:user, member_id: member.id)
      member.user = user
      member.save
      other_user = FactoryGirl.create(:user)
      sign_in_user(other_user)
      visit edit_member_path(member)
      expect(page).to have_content other_user.first_name
    end

    it "lets a user edit their own member page" do
      user = FactoryGirl.create(:user, member_id: member.id)
      member.user = user
      member.save
      sign_in_user(user)
      visit edit_member_path(member)
      fill_in "First name", with: "Regina"
      click_on "Update Member"
      expect(page).to have_content "Regina"
    end
  end
end
