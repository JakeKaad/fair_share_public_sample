require 'rails_helper'

describe StudentsController do
  describe 'GET index' do

    context "as admin" do
      before do
        set_current_admin
      end

      it "sets @students" do
        student_one = FactoryGirl.create(:student)
        student_two = FactoryGirl.create(:student)
        get :index
        expect(assigns(:students)).to eq [student_one, student_two]
      end

      it "sets @families to only include current families" do
        student_one = FactoryGirl.create(:student)
        student_two = FactoryGirl.create(:student)
        student_three = FactoryGirl.create(:student)
        student_three.toggle_archived
        get :index
        expect(assigns(:students)).to eq [student_one, student_two]
      end

      it "sets @familes to include only archived families when archived tab is selected" do
        student_one = FactoryGirl.create(:student)
        student_two = FactoryGirl.create(:student)
        student_three = FactoryGirl.create(:student)
        student_two.toggle_archived
        student_three.toggle_archived
        get :index, tab: "archived"
        expect(assigns(:students)).to eq [student_two, student_three]
      end

      it "sets @families to all when tab is set to all" do
        student_one = FactoryGirl.create(:student)
        student_two = FactoryGirl.create(:student)
        student_two.toggle_archived
        get :index, tab: "all"
        expect(assigns(:students)).to eq [student_one, student_two]
      end
    end

    context "not as admin" do
      let(:action) do
        get :index
      end

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end


  describe 'POST create' do
    context "as an admin" do
      context "with valid input" do
        let(:family) { FactoryGirl.create(:family) }
        let(:classroom) { FactoryGirl.create(:classroom) }
        before do
          @request.env['HTTP_REFERER'] = family_path(family)
          set_current_admin
          post :create, student: FactoryGirl.attributes_for(:student, classroom_id: classroom.id), family_id: family.id
        end

        it "redirects back to family page" do
          expect(response).to redirect_to family_path(family)
        end

        it "creates a new student object" do
          expect(Student.all.size).to eq 1
        end

        it "sets the classroom correctly" do
          expect(Student.first.classroom).to eq classroom
        end

        it "sets enrolled to true" do
          expect(Student.first.enrolled).to be_truthy
        end

        it "sets the family correclty" do
          expect(Student.first.family).to eq family
        end

        it "sets a notice" do
          expect(flash[:notice]).to_not be_empty
        end
      end

      context "with invalid input" do
        let(:family) { FactoryGirl.create(:family) }
        let(:classroom) { FactoryGirl.create(:classroom) }
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          @request.env['HTTP_REFERER'] = family_path(family)
          set_current_admin
          post :create, student: FactoryGirl.attributes_for(:student, classroom_id: classroom.id,
                                                            first_name: ""), family_id: family.id
        end

        it "redirects back to the family page" do
          expect(response).to redirect_to family_path(family)
        end

        it "doesn't save a new student" do
          expect(Student.all).to be_empty
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end

    context "not as admin" do
      let(:family) { FactoryGirl.create(:family) }
      let(:student) { FactoryGirl.attributes_for :student }
      let(:classroom) { FactoryGirl.create(:classroom) }
      let(:action) do
        post :create, student: FactoryGirl.attributes_for(:student, classroom_id: classroom.id), family_id: family.id
      end

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe "GET edit" do
    context "as an admin" do
      let(:student) { FactoryGirl.create(:student) }
      before do
        set_current_admin
        get :edit, id: student.id
      end

      it "sets the @student correctly" do
        expect(assigns(:student)).to eq student
      end
    end

    context "not as admin" do
      let(:student) { FactoryGirl.create(:student)}
      let(:action) { get :edit, id: student.id }

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe 'POST update' do
    context "as an admin" do
      let(:student) { FactoryGirl.create(:student) }
      before do
        set_current_admin
        @request.env['HTTP_REFERER'] = students_path
      end

      context "with valid input" do
        before { post :update, id: student.id, student: { first_name: "Alice" } }

        it "should redirect to the member page" do
          expect(response).to redirect_to students_path
        end

        it "should update the member" do
          expect(student.reload.first_name).to eq "Alice"
        end

        it "should show a success message" do
          expect(flash[:notice]).to_not be_empty
        end
      end

      context "with invalid input" do
        before { post :update, id: student.id, student: { first_name: "" } }

        it "should render the edit template" do
          expect(response).to render_template :edit
        end

        it "should show an alert message" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end

    context "not as admin" do
      let(:student) { FactoryGirl.create(:member)}
      let(:action) { post :update, id: student.id }

      it_behaves_like "require admin"
      it_behaves_like "require login"
    end
  end

  describe "POST archive" do
    context "not as admin" do
      let(:student) { FactoryGirl.create(:student) }
      let(:action) { post :archive, id: student.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end
  end

  context "as an admin" do
    let(:object) { FactoryGirl.create(:student) }
    let(:action) { post :archive, id: object.id }
    let(:redirect_path) { students_path }
    before do
      @request.env['HTTP_REFERER'] = redirect_path
      set_current_admin
    end

    it_behaves_like "archive_path"
  end
end

