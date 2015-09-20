#Unit test macros

def set_current_user(user=nil)
  user ||= FactoryGirl.create(:user)
  sign_in user
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def clear_current_user
  session[:user_id] = nil
end

def set_current_admin(admin=nil)
  admin ||= FactoryGirl.create(:admin)
  sign_in admin
end

def current_admin
  Admin.find(session[:admin_id]) if session[:admin_id]
end

def create_registration_activity
  FactoryGirl.create(:category, name: "Incentives")
  FactoryGirl.create(:activity, name: "Fair Share Online", category_id: Category.first.id)
  FactoryGirl.create(:subactivity, name: "Create Account", activity_id: Activity.first.id)
end

def create_activity_set
  FactoryGirl.create(:category, name: "Auction")
  FactoryGirl.create(:activity, name: "Auction Setup", category_id: Category.first.id)
  FactoryGirl.create(:subactivity, name: "Setup", activity_id: Activity.first.id)
end

#Integration test macros
def sign_in_user(user=nil)
  user ||= FactoryGirl.create(:user)
  login_as(user, scope: :user)
end

def sign_in_admin(admin=nil)
  admin ||= FactoryGirl.create(:admin)
  login_as(admin, scope: :admin)
end

def go_home
  visit root_path
end
