require 'rails_helper'

describe FamiliesController do
  describe 'GET new' do
    context 'as Admin' do
      it 'sets @family' do
        set_current_admin
        get :new
        expect(assigns(:family)).to be_a_new(Family)
      end
    end

    context "not logged as admin" do
      let(:action) { get :new }
      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe 'POST create' do
    context "as admin" do
      before { set_current_admin }

      context "with valid input" do
        before { post :create, family: { name: "The Smiths"} }

        it "creates a new family" do
          expect(Family.all.size).to eq 1
        end

        it "redirects to the new family's show page" do
          expect(response).to redirect_to Family.first
        end

        it "shows a notice  message" do
          expect(flash[:notice]).to_not be_empty
        end
      end

      context "with invalid input" do
        before { post :create, family: {name: ""} }

        it "doesn't create a new family" do
          expect(Family.all).to be_empty
        end

        it "renders :new" do
          expect(response).to render_template :new
        end

        it "shows an alert message" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end

    context "not logged as admin" do
      let(:action) { post :create, family: { name: "The Smiths"} }
      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe "GET show" do
    context "as an admin" do
      let(:family) { FactoryGirl.create(:family) }
      before do
        set_current_admin
        get :show, id: family.id
      end

      it "sets @family" do
        expect(assigns(:family)).to eq family
      end

      it "sets @student as a new instance" do
        expect(assigns(:student)).to be_a_new Student
      end

      it "sets @member as a new instance" do
        expect(assigns(:member)).to be_a_new Member
      end


    end

    context "as a user" do
      let(:family) { FactoryGirl.create(:family) }
      before do
        set_current_user
        get :show, id: family.id
      end

      it "sets @family" do
        expect(assigns(:family)).to eq family
      end

      it "doesn't set @student" do
        expect(assigns(:student)).to be_nil
      end

      it "doesn't set @member" do
        expect(assigns(:member)).to be_nil
      end

      it "assigns @students correctly" do
        student_one = FactoryGirl.create(:student, family: family)
        student_two = FactoryGirl.create(:student, family: family)
        expect(assigns(:students)).to eq [student_one, student_two]
      end

      it "assigns @members correctly" do
        member_one = FactoryGirl.create(:member, family: family)
        member_two = FactoryGirl.create(:member, family: family)
        expect(assigns(:members)).to eq [member_one, member_two]
      end
    end
  end

  it_behaves_like "require login" do
    let(:action)  { get :show, id: FactoryGirl.create(:family).id }
  end

  describe "GET index" do
    context "not as an admin" do
      let(:action) { get :index }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as an admin" do
      before { set_current_admin }

      it "sets @families" do
        family_one = FactoryGirl.create(:family)
        family_two = FactoryGirl.create(:family)
        get :index
        expect(assigns(:families)).to eq [family_one, family_two]
      end

      it "sets @families to only include current families" do
        family_one = FactoryGirl.create(:family)
        family_two = FactoryGirl.create(:family)
        family_three = FactoryGirl.create(:family)
        family_three.toggle_archived
        get :index
        expect(assigns(:families)).to eq [family_one, family_two]
      end

      it "sets @familes to include only archived families when archived tab is selected" do
        family_one = FactoryGirl.create(:family)
        family_two = FactoryGirl.create(:family)
        family_three = FactoryGirl.create(:family)
        family_two.toggle_archived
        family_three.toggle_archived
        get :index, tab: "archived"
        expect(assigns(:families)).to eq [family_two, family_three]
      end

      it "sets @families to all when tab is set to all" do
        family_one = FactoryGirl.create(:family)
        family_two = FactoryGirl.create(:family)
        get :index
        expect(assigns(:families)).to eq [family_one, family_two]
      end
    end
  end

  describe "POST archive" do
    context "not as admin" do
      let(:family) { FactoryGirl.create(:family) }
      let(:action) { post :archive, id: family.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end
  end

  context "as an admin" do
    let(:object) { FactoryGirl.create(:family) }
    let(:action) { post :archive, id: object.id }
    let(:redirect_path) { families_path }
    before do
      @request.env['HTTP_REFERER'] = redirect_path
      set_current_admin
    end

    it_behaves_like "archive_path"
  end
end



