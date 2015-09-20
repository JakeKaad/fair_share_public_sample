require 'rails_helper'

describe StaticPagesController do
  describe 'GET home' do
    it 'renders the home template' do
        get :home
        expect(response).to render_template :home
    end
  end

  describe 'GET help' do
    it 'renders the help template' do
        get :help
        expect(response).to render_template :help
    end
  end
end
