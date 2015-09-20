shared_examples "require login" do
  it "redirects to the login page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "require admin" do
  it "redirects to the user's root path" do
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "require access" do
  it "redirects to the user's root path" do
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end


shared_examples "integration require admin" do
  it "should redirect to the root path" do
    user = FactoryGirl.create(:user)
    login_as(user, scope: user)
    action
    # This needs to be changed after we have a user dashboard added
    expect(page).to have_content "Welcome"
  end
end

shared_examples "integration require login" do
  it "should redirect to the root path" do
    action
    # This needs to be changed after we have a user dashboard added
    expect(page).to have_content 'Sign In'
  end
end
