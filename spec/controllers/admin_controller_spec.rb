require 'rails_helper'

describe AdminController do
  describe 'get SHOW' do
    context 'not as an admin' do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:action) { get :show, id: admin.id }
      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe 'get send_registration_emails' do
    context 'as an admin' do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        set_current_admin(admin)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "redirects to admin show page" do
        get :send_registration_emails
        expect(response).to redirect_to admin
      end

      it "sets users to all unregistered users" do
        alice = FactoryGirl.create(:user, registration_token: "abc123")
        john = FactoryGirl.create(:user, registration_token: "abc123")
        FactoryGirl.create(:user, registration_token: "")
        get :send_registration_emails
        expect(assigns(:unregistered_users)).to eq [alice, john]
      end

      it "sends a registration email to each unregistered user" do
        alice = FactoryGirl.create(:user, registration_token: "abc123")
        john = FactoryGirl.create(:user, registration_token: "abc123")
        FactoryGirl.create(:user, registration_token: "")
        get :send_registration_emails
        expect(ActionMailer::Base.deliveries.size).to eq 2
      end
    end

    context 'not as an admin' do
      let(:action) { get :send_registration_emails }
      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end
end
