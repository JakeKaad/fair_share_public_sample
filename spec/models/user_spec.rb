require 'rails_helper'

describe User do
  it { should belong_to :member }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :member }

  describe "User#create_unregistered_user" do
    it "should create a new user" do
      User.create_unregistered_user(FactoryGirl.create(:member))
      expect(User.first).to_not be_nil
    end

    it "it creates an association to member" do
      member = FactoryGirl.create(:member)
      user = User.create_unregistered_user(member)
      expect(member.user).to eq user
    end

    it "sets a registration token" do
      User.create_unregistered_user(FactoryGirl.create(:member))
      expect(User.first.registration_token).to_not be_nil
    end
  end

  describe "User#registered?" do
    it "is true if registration_token is nil" do
      user = FactoryGirl.create(:user)
      expect(user.registered?).to be_truthy
    end

    it "is false if there is a registration_token" do
      user = FactoryGirl.create(:user, registration_token: '1234')
      expect(user.registered?).to be_falsey
    end
  end
end
