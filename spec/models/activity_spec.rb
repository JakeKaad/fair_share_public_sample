require 'rails_helper'

describe Activity do
  it { should have_and_belong_to_many :members }
  it { should belong_to :category }
  it { should have_many :subactivities }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:member) }
    let(:archivable) { Member }
  end
end
