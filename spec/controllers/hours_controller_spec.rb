require 'rails_helper'

describe HoursController do
  describe 'GET index' do
    it_behaves_like "require login" do
      let(:action) { get :index }
    end

    context 'as a family member' do
      let(:family) { FactoryGirl.create(:family) }
      let(:member) { FactoryGirl.create(:member, family_id: family.id) }
      let(:hour) { FactoryGirl.create(:hour, member_id: member.id) }

      before do
        member.user = FactoryGirl.create(:user)
        set_current_user
        get :index, family_id: family.id
      end

      it "sets @family" do
        expect(assigns(:family)).to eq family
      end

      it "sets @hours" do
        expect(assigns(:hours)).to eq [hour]
      end

      it "sets @hour" do
        expect(assigns(:hour)).to be_a Hour
      end
    end
  end

  describe 'POST create' do
    it_behaves_like "require login" do
      let(:action) { post :create, hour: {member_id: member.id, quantity: 1, submitted_by_id: 0, subactivity_id: 1, activity_id: 1, date_earned: Time.now }, family_id: family.id }
    end

    let(:family) { FactoryGirl.create(:family) }
    let(:member) { FactoryGirl.create(:member, family_id: family.id) }

    context "as an admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do

        set_current_admin(admin)
        @request.env['HTTP_REFERER'] = family_path(family)
        post :create, hour: {member_id: member.id, quantity: 1, submitted_by_id: 0 - admin.id, subactivity_id: 1, activity_id: 1, date_earned: Time.now }, family_id: family.id
      end

      it "it creates an hour" do
        expect(Hour.all).to_not be_empty
      end

      it "sets the submitted_by_id to 0" do
        expect(Hour.first.submitted_by_id).to eq 0 - admin.id
      end
    end

    context "as a family member" do
      context "with valid input" do
        before do
          member.user = FactoryGirl.create(:user)
          set_current_user(member.user)
          @request.env['HTTP_REFERER'] = family_path(family)
          post :create, hour: {member_id: member.id, quantity: 1, submitted_by_id: member.user.id, subactivity_id: 1, activity_id: 1, date_earned: Time.now }, family_id: family.id
        end

        after do
          ActionMailer::Base.deliveries.clear
        end

        it "redirects back" do
          expect(response).to redirect_to family_path(family)
        end

        it "creates an hour" do
          expect(family.reload.hours).to eq [Hour.first]
        end
      end

      context "with invalid input" do
        before do
          member.user = FactoryGirl.create(:user)
          set_current_user(member.user)
          @request.env['HTTP_REFERER'] = family_path(family)
          post :create, hour: {member_id: member.id, quantity: 1, submitted_by_id: member.user.id, subactivity_id: 1, activity_id: 1, date_earned: "Time.now" }, family_id: family.id
        end

        it "doesn't create an hour" do
          expect(family.reload.hours).to eq []
        end
      end
    end
  end

  describe "GET edit" do
    context "without access" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:action) { get :edit, id: hour.id }

      it_behaves_like "require login"
      it_behaves_like "require access"
    end

    context "as an admin" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:activity) {  FactoryGirl.create(:activity) }
      before do
        set_current_admin
        create_registration_activity
        get :edit, id: hour.id
      end

      it "sets @hour" do
        expect(assigns(:hour)).to eq hour
      end

      it "sets @family" do
        expect(assigns(:family)).to eq hour.member.family
      end

      it "sets activities to all except incentives" do
        expect(assigns(:activities).include? activity).to be_truthy
      end

      it "sets subactivities to all active subactivities" do
        expect(assigns(:subactivities)).to eq Subactivity.active
      end
    end

    context "as an admin" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:activity) {  FactoryGirl.create(:activity) }
      before do
        set_current_admin
        create_registration_activity
        get :edit, id: hour.id
      end

      it "sets @hour" do
        expect(assigns(:hour)).to eq hour
      end

      it "sets @family" do
        expect(assigns(:family)).to eq hour.member.family
      end

      it "sets activities to all except incentives" do
        expect(assigns(:activities).include? activity).to be_truthy
      end

      it "sets subactivities to all active subactivities" do
        expect(assigns(:subactivities)).to eq Subactivity.active
      end
    end

    context "as a family member" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:activity) {  FactoryGirl.create(:activity) }
      let(:member) { hour.member}
      let(:user) { FactoryGirl.create(:user, member_id: member.id) }
      before do
        set_current_user(user)
        get :edit, id: hour.id
      end

       it "sets @hour" do
        expect(assigns(:hour)).to eq hour
      end

      it "sets @family" do
        expect(assigns(:family)).to eq hour.member.family
      end

      it "sets activities to all except incentives" do
        expect(assigns(:activities).include? activity).to be_truthy
      end

      it "sets subactivities to all active subactivities" do
        expect(assigns(:subactivities)).to eq Subactivity.active
      end
    end
  end

  describe "POST update" do
    context "without access" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:action) { post :update, id: hour.id, hour: { date_earned: Time.now } }

      it_behaves_like "require login"
      it_behaves_like "require access"
    end

    context "as admin" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:subactivity) { FactoryGirl.create(:subactivity)}

      context "with valid input" do
        before do
        set_current_admin
          post :update, id: hour.id, hour: { subactivity_id: subactivity.id }
        end

        it "sets @hour" do
          expect(assigns(:hour)).to eq hour
        end

        it "updates @hour" do
          expect(hour.reload.subactivity).to eq subactivity
        end

        it "redirects correctly to the family hours index" do
          expect(response).to redirect_to family_hours_path(hour.family)
        end
      end

      context "with invalid input" do
        before do
        set_current_admin
          post :update, id: hour.id, hour: { date_earned: Time.now.tomorrow }
        end

        it "renders the edit template" do
          expect(response).to render_template :edit
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end

    context "as a family member" do
      let(:hour) { FactoryGirl.create(:hour) }
      let(:subactivity) { FactoryGirl.create(:subactivity)}
      let(:member) { hour.member}
      let(:user) { FactoryGirl.create(:user, member_id: member.id) }

      context "with valid input" do
        before do
          set_current_user(user)
          post :update, id: hour.id, hour: { subactivity_id: subactivity.id }
        end

        it "sets @hour" do
          expect(assigns(:hour)).to eq hour
        end

        it "updates @hour" do
          expect(hour.reload.subactivity).to eq subactivity
        end

        it "redirects correctly to the family hours index" do
          expect(response).to redirect_to family_hours_path(hour.family)
        end
      end

      context "with invalid input" do
        before do
          set_current_user(user)
          post :update, id: hour.id, hour: { date_earned: Time.now.tomorrow }
        end

        it "renders the edit template" do
          expect(response).to render_template :edit
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end
  end
end
