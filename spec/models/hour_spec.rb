require 'rails_helper'

describe Hour do
  it { should belong_to :member }
  it { should belong_to :submitted_by }
  it { should belong_to :subactivity }
  it { should validate_presence_of :date_earned }
  it { should validate_presence_of :member_id }
  it { should validate_presence_of :subactivity_id }
  it { should validate_presence_of :quantity }
  it { should validate_numericality_of :quantity }
  it { should validate_numericality_of(:quantity).is_less_than(500)}
  it { should validate_numericality_of(:quantity).is_greater_than(0)}

  describe '#default_scope' do
    let!(:hour_one) { FactoryGirl.create(:hour, date_earned: Time.zone.yesterday) }
    let!(:hour_two) { FactoryGirl.create(:hour, date_earned: Time.zone.today) }

    it 'should be ordered by date_earned desc' do
      expect(Hour.all).to eq [hour_two, hour_one]
    end
  end

  describe '#date_in_current_year' do
    it "saves with valid input" do
      hour = FactoryGirl.build(:hour, date_earned: Time.zone.local(2015, 7, 1))
      expect(hour.save).to be_truthy
    end

    it "doesn't save when before school year" do
      hour = FactoryGirl.build(:hour, date_earned: Time.zone.local(2015, 6, 30))
      expect(hour.save).to be_falsey
    end

    it "doesn't save when after school year" do
      hour = FactoryGirl.build(:hour, date_earned: Time.zone.local(2016, 7, 2))
      expect(hour.save).to be_falsey
    end
  end
end
