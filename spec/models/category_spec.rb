require 'rails_helper'

describe Category do
  it { should have_many :activities }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  describe "#archive_category" do
    let!(:category) { FactoryGirl.create(:category) }
    let!(:activity) { FactoryGirl.create(:activity, category_id: category.id) }
    let!(:subactivity) { FactoryGirl.create(:subactivity, activity_id: activity.id) }

    it "should archive the category if it isn't archived" do
      category.archive_category
      expect(category.reload.archived).to be_truthy
    end

    it "should unarchive the category if it isn't archived" do
      category.toggle_archived
      category.archive_category
      expect(category.reload.archived).to be_falsey
    end

    it "should archive all activities belonging to category" do
      category.reload.archive_category
      expect(activity.reload.archived).to be_truthy
    end

    it "should archive all subactivities belonging to category's activities" do
      category.reload.archive_category
      expect(subactivity.reload.archived).to be_truthy
    end
  end

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:category) }
    let(:archivable) { Category }
  end
end
