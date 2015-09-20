require 'rails_helper'

describe Subactivity do
  it { should belong_to :activity }
  it { should have_many :hours }
  it { should validate_presence_of :name }

  it_behaves_like "archivable" do
    let!(:object) { FactoryGirl.create(:subactivity) }
    let(:archivable) { Subactivity }
  end
end
