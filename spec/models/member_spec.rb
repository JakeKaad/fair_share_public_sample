require 'rails_helper'

describe Member do
  it { should belong_to :family }
  it { should have_many(:students).through(:family) }
  it { should have_many(:hours) }
  it { should have_many(:submitted_bys).class_name('Member').through(:hours) }
  it { should have_one(:user) }
  it { should have_and_belong_to_many(:activities) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  describe("Member#full_name") do
    it "returns the full name" do
      test_member = Member.create(first_name: "TestFirstName", last_name: "TestLastName")
      expect(test_member.full_name).to eq "TestFirstName TestLastName"
    end
  end

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:member) }
    let(:archivable) { Member }
  end
end
