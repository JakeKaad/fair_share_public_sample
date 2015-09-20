require 'rails_helper'

describe MembersController do
  describe "POST create" do
    context "as an admin" do
      context "with valid input" do
        let(:family) { FactoryGirl.create(:family) }
        before do
          @request.env['HTTP_REFERER'] = family_path(family)
          set_current_admin
          post :create, member: FactoryGirl.attributes_for(:member), family_id: family.id
        end

        it "redirects back to family page" do
          expect(response).to redirect_to family_path(family)
        end

        it "creates a member" do
          expect(Member.all.size).to eq 1
        end

        it "sets the family correctly" do
          expect(Member.first.family).to eq family
        end

        it "sets a notice" do
          expect(flash[:notice]).to_not be_empty
        end

        it "creates an associated user" do
          expect(Member.first.user).to_not be_nil
        end
      end

      context "with invalid input" do
        let(:family) { FactoryGirl.create(:family) }
        before do
          @request.env['HTTP_REFERER'] = family_path(family)
          set_current_admin
          post :create, member: FactoryGirl.attributes_for(:member, first_name: ""), family_id: family.id
        end

        it "redirects back to family page" do
          expect(response).to redirect_to family_path(family)
        end

        it "doesn't create a member" do
          expect(Member.all.size).to eq 0
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end


    context "not as an admin" do
      let(:family) { FactoryGirl.create(:family) }
      let(:action) { post :create, member: FactoryGirl.attributes_for(:member), family_id: family.id }

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe "GET index" do
    context "not as an admin" do
      let(:action) { get :index }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as an admin" do
      before { set_current_admin }

      it "sets @members" do
        member_one = FactoryGirl.create(:member)
        member_two = FactoryGirl.create(:member)
        get :index
        expect(assigns(:members)).to eq [member_one, member_two]
      end

      it "sets @members to only include current families" do
        member_one = FactoryGirl.create(:member)
        member_two = FactoryGirl.create(:member)
        member_three = FactoryGirl.create(:member)
        member_three.toggle_archived
        get :index
        expect(assigns(:members)).to eq [member_one, member_two]
      end

      it "sets @members to include only archived families when archived tab is selected" do
        member_one = FactoryGirl.create(:member)
        member_two = FactoryGirl.create(:member)
        member_three = FactoryGirl.create(:member)
        member_two.toggle_archived
        member_three.toggle_archived
        get :index, tab: "archived"
        expect(assigns(:members)).to eq [member_two, member_three]
      end

      it "sets @members to all when tab is set to all" do
        member_one = FactoryGirl.create(:member)
        member_two = FactoryGirl.create(:member)
        get :index
        expect(assigns(:members)).to eq [member_one, member_two]
      end
    end
  end

  describe "GET edit" do
    context "as an admin" do
      let(:member) { FactoryGirl.create(:member) }
      before do
        set_current_admin
        get :edit, id: member.id
      end

      it "sets the @member correctly" do
        expect(assigns(:member)).to eq member
      end
    end

    context "as owner" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.member.update(user_id: user.id)
        set_current_user(user)
        get :edit, id: user.member.id
      end

      it "renders the edit page" do
        expect(response).to_not redirect_to root_path
      end

      it "sets the @member correctly" do
        expect(assigns(:member)).to eq user.member
      end
    end

    context "not as admin or owner" do
      let(:member) { FactoryGirl.create(:member)}
      let(:action) { get :edit, id: member.id }

      #TODO - ADD "require correct user"
      it_behaves_like "require login"
    end
  end

  describe 'POST update' do
    context "as an admin" do
      let(:member) { FactoryGirl.create(:member) }
      let(:user) { FactoryGirl.create(:user) }
      before do
        set_current_admin
        member.user = user
      end

      context "with valid input" do
        before { post :update, id: member.id, member: { first_name: "Alice", email: "alice@wonderland.com" } }

        it "should redirect to the member page" do
          expect(response).to redirect_to member_path(member)
        end

        it "should update the member" do
          expect(member.reload.first_name).to eq "Alice"
        end

        it "should show a success message" do
          expect(flash[:notice]).to_not be_empty
        end

        it "should update the members user account email" do
          expect(user.reload.email).to eq "alice@wonderland.com"
        end
      end

      context "with invalid input" do
        before { post :update, id: member.id, member: { first_name: "" } }

        it "should render the edit template" do
          expect(response).to render_template :edit
        end

        it "should show an alert message" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end

    context "as owner" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.member.update(user_id: user.id)
        set_current_user(user)
      end

      it "allows an owner to update" do
        post :update, id: user.member.id, member: { first_name: "Alice" }
        expect(flash[:notice]).to_not be_empty
      end

      it "doesnt allow current user to edit other profiles" do
        other_user = FactoryGirl.create(:user)
        other_user.member.update(user_id: other_user.id)
        post :update, id: other_user.member.id, member: { first_name: "Alice" }
        expect(response).to redirect_to root_path
      end
    end

    context "not as admin or owner" do
      let(:member) { FactoryGirl.create(:member)}
      let(:action) { post :update, id: member.id }

      #TODO - ADD "require correct user"
      it_behaves_like "require login"
    end
  end

  describe "POST add_activity" do
    context "as owner" do
       let(:user) { FactoryGirl.create(:user) }
       let(:activity) { FactoryGirl.create(:activity) }

      before do
        user.member.update(user_id: user.id)
        set_current_user(user)
      end

      it "allows an owner to add an interest" do
        post :add_activity, member_id: user.member.id, activity_id: activity.id
        expect(user.member.reload.activities).to include activity
      end

      it "doesnt allow current user to edit other profiles" do
        other_user = FactoryGirl.create(:user)
        other_user.member.update(user_id: other_user.id)
        post :add_activity, member_id: other_user.member.id, activity_id: activity.id
        expect(other_user.member.activities).to_not include activity
      end
    end
  end

  describe "POST remove_activity" do
    context "as owner" do
       let(:user) { FactoryGirl.create(:user) }
       let(:activity) { FactoryGirl.create(:activity) }

      before do
        user.member.update(user_id: user.id)
        set_current_user(user)
      end

      it "allows an owner to remove an interest" do
        user.member.activities.push(activity)
        post :remove_activity, member_id: user.member.id, activity_id: activity.id
        expect(user.member.reload.activities).to_not include activity
      end

      it "doesnt allow current user to edit other profiles" do
        other_user = FactoryGirl.create(:user)
        other_user.member.update(user_id: other_user.id)
        other_user.member.activities.push(activity)
        post :remove_activity, member_id: other_user.member.id, activity_id: activity.id
        expect(other_user.member.activities).to include activity
      end
    end
  end

  describe "GET invite" do
    context "as admin" do
      let(:member) { FactoryGirl.create(:member) }
      before do
        set_current_admin
        member.user = FactoryGirl.create(:user)
        @request.env['HTTP_REFERER'] = members_path
      end
      after { ActionMailer::Base.deliveries.clear }

      it "sets the member properly" do
        get :invite, id: member.id
        expect(assigns(:member)).to eq member
      end

      it "sends an invitiation email" do
        get :invite, id: member.id
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
    end

    context "not as admin" do
      let(:family) { FactoryGirl.create(:family) }
      let(:member) { FactoryGirl.create(:member) }
      let(:action) { get :invite, id: member.id }

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe "POST archive" do
    context "not as admin" do
      let(:member) { FactoryGirl.create(:member) }
      let(:action) { post :archive, id: member.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end
  end

  context "as an admin" do
    let(:object) { FactoryGirl.create(:member) }
    let(:action) { post :archive, id: object.id }
    let(:redirect_path) { members_path }
    before do
      @request.env['HTTP_REFERER'] = redirect_path
      set_current_admin
    end

    it_behaves_like "archive_path"
  end
end
