require 'rails_helper'

describe "editing student information" do
  context "as an admin" do
    let!(:student) { FactoryGirl.create(:student) }

    it "displays edit button on student index" do
      sign_in_admin
      visit students_path
      click_on "Edit"
      expect(page).to have_content "Edit"
    end

    it "allows an admin to update student information" do
      sign_in_admin
      visit edit_student_path(student)
      fill_in "First name", with: "Rebel"
      click_on "Update Student"
      expect(page).to have_content "Rebel"
    end

    it "doesn't update with invalid information" do
      sign_in_admin
      visit edit_student_path(student)
      fill_in "First name", with: ""
      click_on "Update Student"
      expect(page).to have_content "Something went wrong"
    end
  end

  context 'not as admin' do
    let(:student) { FactoryGirl.create(:student) }
    let(:action) { visit edit_student_path(student) }

    it_behaves_like 'integration require login'
    it_behaves_like 'integration require admin'
  end
end
