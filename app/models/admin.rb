class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # 8/2/15 Removed :registerable to prevent users from signing up as admins - kb
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

end
