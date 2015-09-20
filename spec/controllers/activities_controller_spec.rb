require 'rails_helper'

describe ActivitiesController do
  describe "POST archive" do
    context "not as admin" do
      let(:member) { FactoryGirl.create(:member) }
      let(:action) { post :archive, id: member.id }

      it_behaves_like "require login"
      it_behaves_like "require admin"
    end
  end

  context "as an admin" do
    let(:object) { FactoryGirl.create(:activity) }
    let(:action) { post :archive, id: object.id }
    let(:redirect_path) { category_path(object.category) }
    before do
      @request.env['HTTP_REFERER'] = redirect_path
      set_current_admin
    end

    it_behaves_like "archive_path"
  end
end
