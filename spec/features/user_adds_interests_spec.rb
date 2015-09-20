require 'rails_helper'

describe 'user adding interest' do
  let(:user) { FactoryGirl.create(:user) }
  let(:member) { FactoryGirl.create(:member) }
  before do
    create_activity_set
    user.member = member
    member.user = user
    login_as(user.reload, scope: :user)
  end

  it "adds an interest", js: true do
    go_home
    activity_checkbox = page.find(".activity-checkbox").first
    check activity_checkbox
    go_home
    activity_checkbox = page.find(".activity-checkbox")
    expect(activity_checkbox).to be_checked
  end
end

describe 'user adding all interests' do
  let(:user) { FactoryGirl.create(:user) }
  let(:member) { FactoryGirl.create(:member) }
  before do
    create_activity_set
    FactoryGirl.create(:activity, category_id: Category.last.id)
    FactoryGirl.create(:activity, category_id: Category.last.id)
    user.member = member
    member.user = user
    login_as(user.reload, scope: :user)
  end

  it "adds all interests when button seleted", js: true do
    go_home
    click_on "Select All"
    go_home
    expect(page.find("#activity_ids_1")).to be_checked
    expect(page.find("#activity_ids_2")).to be_checked
    expect(page.find("#activity_ids_3")).to be_checked
  end

   it "removes all interests when button seleted", js: true do
    go_home
    click_on "Select All"
    go_home
    click_on "Remove All"
    go_home
    expect(page.find("#activity_ids_1")).to_not be_checked
    expect(page.find("#activity_ids_2")).to_not be_checked
    expect(page.find("#activity_ids_3")).to_not be_checked
  end
end
