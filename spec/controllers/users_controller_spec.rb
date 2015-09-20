require 'rails_helper'

describe UsersController do
  describe 'GET new_with_registration_token' do
    context "with valid token" do
      let(:alice) { FactoryGirl.create(:user, registration_token: "abc123") }
      before { get :new_with_registration_token, registration_token: alice.registration_token }

      it "should render the :update template" do
        expect(response).to render_template :edit
      end

      it "should set @user to user with registration_token" do
        expect(assigns(:user)).to eq alice
      end

      it "should render a flash notice telling user what to do" do
        expect(flash[:notice]).to_not be_empty
      end
    end

    context "with invalid token" do
      let(:alice) { FactoryGirl.create(:user) }
      before { get :new_with_registration_token, registration_token: "1234567" }

      it "should redirect to the root_path" do
        expect(response).to redirect_to root_path
      end

      it "should render a flash alert stating token invalid" do
        expect(flash[:alert]).to_not be_empty
      end
    end
  end

  describe 'POST update' do
    context 'with valid input' do
      let(:alice) { FactoryGirl.create(:user, registration_token: "abc123") }
      before do
        set_current_user alice
        create_registration_activity
      end
      after { ActionMailer::Base.deliveries.clear }


      it "should redirect to the sign_in_path" do
        post :update, user: {password: "new_password", password_confirmation: "new_password", registration_token: alice.registration_token}, id: alice.id
        expect(response).to redirect_to root_path
      end

      it "should update the user's password" do
        old_password = alice.encrypted_password
        post :update, user: {password: "new_password", password_confirmation: "new_password", registration_token: alice.registration_token}, id: alice.id
        expect(alice.reload.encrypted_password).to_not eq old_password
      end

      it "should set the flash notice" do
        post :update, user: {password: "new_password", password_confirmation: "new_password", registration_token: alice.registration_token}, id: alice.id
        expect(flash[:notice]).to_not be_empty
      end

      it "should clear the registration token from the user" do
        post :update, user: {password: "new_password", password_confirmation: "new_password", registration_token: alice.registration_token}, id: alice.id
        expect(alice.reload.registration_token).to be_empty
      end

      it "should send a registered email" do
        post :update, user: {password: "new_password", password_confirmation: "new_password", registration_token: alice.registration_token}, id: alice.id
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context 'with invalid input' do
      let(:alice) { FactoryGirl.create(:user, registration_token: "abc123") }
      before do
        set_current_user alice
        post :update, user: {password: "new_password", password_confirmation: "password", registration_token: alice.registration_token}, id: alice.id
      end


      it "should render :edit" do
        expect(response).to render_template :edit
      end

      it "shouldnt reset registration_token" do
        expect(alice.reload.registration_token).to be_present
      end

      it "shouldn't reset the password" do
        expect(alice.encrypted_password).to eq alice.reload.encrypted_password
      end
    end

    context 'with no registration_token' do
      let(:alice) { FactoryGirl.create(:user, registration_token: "abc123") }
      before do
        post :update, user: {password: "new_password", password_confirmation: "new_password"}, id: alice.id
      end

      it "should redirect to the root path" do
        expect(response).to redirect_to new_user_session_path
      end

      it "should not reset the password" do
        expect(alice.encrypted_password).to eq alice.reload.encrypted_password
      end
    end
  end
end
