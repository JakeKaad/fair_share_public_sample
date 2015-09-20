require 'rails_helper'

describe "user adding new interests on member page" do
   let(:alice) { FactoryGirl.create(:user) }
   let!(:activity) { FactoryGirl.create(:activity) }
   let(:member) { alice.member }
   before { login_as(alice, scope: :user) }

  it "should add a new interest when clicking on a checkbox", js: true  do
    visit member_path(member)
    check "activity_ids_#{activity.id}"
    visit member_path(member)
    expect(find("#activity_ids_#{activity.id}")).to be_checked
  end

  it "should remove an interest when unchecking a checkbox", js: true  do
    visit member_path(member)
    check "activity_ids_#{activity.id}"
    uncheck "activity_ids_#{activity.id}"
    visit member_path(member)
    expect(find("#activity_ids_#{activity.id}")).to_not be_checked
  end
end
