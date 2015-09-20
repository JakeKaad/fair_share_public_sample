require 'rails_helper'

describe Family do
  it { should have_many :students }
  it { should have_many :members }
  it { should have_many(:hours).through(:members) }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it "has archived set to false on creation" do
    family = Family.create(name: "The Does")
    expect(family.archived).to eq false
  end

  describe '#archive_family' do
    let(:family) { FactoryGirl.create(:family) }
    before do
      family.members.push FactoryGirl.create(:member)
      family.students.push FactoryGirl.create(:student)
      family.archive_family
    end

    it "archives the family" do
      expect(family.archived).to be_truthy
    end

    it "archives members of the family" do
      expect(family.members.first.archived).to be_truthy
    end

    it "archives students of the family" do
      expect(family.students.first.archived).to be_truthy
    end
  end

  describe "#has_registration_hour?" do
    let(:family) { FactoryGirl.create(:family) }
    before { family.members.push FactoryGirl.create(:member) }

    it "is false if no hours exist" do
      expect(family.has_registration_hour?).to be_falsey
    end

    it "is false if family has no registration hour" do
      member = FactoryGirl.create(:member, family_id: family.id)
      subactivity = FactoryGirl.create(:subactivity)
      hour = FactoryGirl.create(:hour, subactivity_id: subactivity.id, member_id: member.id)
      expect(family.reload.has_registration_hour?).to be_falsey
    end

    it "is true if family has registration hour" do
      member = FactoryGirl.create(:member, family_id: family.id)
      subactivity = FactoryGirl.create(:subactivity, name: "Create Account")
      hour = FactoryGirl.create(:hour, subactivity_id: subactivity.id, member_id: member.id)
      expect(family.reload.has_registration_hour?).to be_truthy
    end
  end

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:family) }
    let(:archivable) { Family }
  end
end
