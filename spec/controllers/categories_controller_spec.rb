require 'rails_helper'

describe CategoriesController do
  describe "POST archive" do
    context "not as admin" do
      let(:member) { FactoryGirl.create(:member) }
      let(:action) { post :archive, id: member.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end
  end

  context "as an admin" do
    let(:object) { FactoryGirl.create(:category) }
    let(:action) { post :archive, id: object.id }
    let(:redirect_path) { categories_path }
    before do
      @request.env['HTTP_REFERER'] = redirect_path
      set_current_admin
    end

    it_behaves_like "archive_path"
  end

  describe "GET index" do
    context "not as admin" do
      let(:action) { get :index }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as admin" do
      before { set_current_admin }

      it "sets @categories to active categories" do
        category_one = FactoryGirl.create(:category)
        category_two = FactoryGirl.create(:category)
        category_three = FactoryGirl.create(:category)
        category_one.toggle_archived
        get :index
        expect(assigns(:categories)).to eq [category_two, category_three]
      end

      it "sets @activities to active activities" do
        act_one = FactoryGirl.create(:activity)
        act_two = FactoryGirl.create(:activity)
        act_three = FactoryGirl.create(:activity)
        act_one.toggle_archived
        get :index
        expect(assigns(:activities)).to eq [act_two, act_three]
      end

      it "sets @category" do
        get :index
        expect(assigns(:category)).to be_instance_of Category
      end
    end
  end

  describe "POST create" do
    context "not as admin" do
      let(:action) { post :create }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as admin" do
      let(:category) { FactoryGirl.build(:category) }
      before { set_current_admin }

      context "with valid input" do
        before { post :create, category: { name: category.name } }
        it "saves a new category object" do
          expect(Category.first.name).to eq category.name
        end

        it "redirects to the categories path" do
          expect(response).to redirect_to categories_path
        end

        it "creates a notice" do
          expect(flash[:notice]).to_not be_empty
        end
      end

      context "with invalid input" do
        before do
          @request.env['HTTP_REFERER'] = categories_path
          post :create, category: { name: "" }
        end

        it "doesn't save an object" do
          expect(Category.count).to eq 0
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end
  end

  describe "GET show" do
    context "not as admin" do
      let(:category) { FactoryGirl.create(:category) }
      let(:action) { get :show, id: category.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as admin" do
      let(:category) { FactoryGirl.create(:category) }
      before do
        set_current_admin
      end

      it "assigns @category" do
        get :show, id: category.id
        expect(assigns(:category)).to eq category
      end

      it "assigns @activities to active activities" do
        act_one = FactoryGirl.create(:activity, category_id: category.id)
        act_two = FactoryGirl.create(:activity, category_id: category.id)
        act_three = FactoryGirl.create(:activity, category_id: category.id)
        act_one.toggle_archived
        get :show, id: category.id
        expect(assigns(:activities)).to eq [act_two, act_three]
      end

      it "assigns @activity" do
        get :show, id: category.id
        expect(assigns(:activity)).to be_instance_of Activity
      end
    end
  end

  describe "GET edit" do
    context "not as admin" do
      let(:category) { FactoryGirl.create(:category) }
      let(:action) { get :edit, id: category.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as admin" do
      let(:category) { FactoryGirl.create(:category) }
      before do
        set_current_admin
      end

      it "sets @category" do
        get :edit, id: category.id
        expect(assigns(:category)).to eq category
      end
    end
  end

  describe "POST update" do
    let(:category) { FactoryGirl.create(:category) }
    context "not as admin" do
      let(:action) { post :update, category: { name: "New Name" }, id: category.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end

    context "as admin" do

      before { set_current_admin }

      context "with valid input" do
        before { post :update, category: { name: "New Name" }, id: category.id }
        it "updates" do
          expect(Category.first.name).to eq "New Name"
        end

        it "redirects to the category path" do
          expect(response).to redirect_to category_path(category)
        end

        it "creates a notice" do
          expect(flash[:notice]).to_not be_empty
        end
      end

      context "with invalid input" do
        before do
          @request.env['HTTP_REFERER'] = categories_path
          post :create, category: { name: "" }, id: category.id
        end

        it "doesn't update an object" do
          expect(Category.first.name).to eq category.name
        end

        it "sets an alert" do
          expect(flash[:alert]).to_not be_empty
        end
      end
    end
  end
end
