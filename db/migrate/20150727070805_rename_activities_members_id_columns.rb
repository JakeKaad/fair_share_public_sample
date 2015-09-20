class RenameActivitiesMembersIdColumns < ActiveRecord::Migration
  def change
    rename_column :activities_members, :activities_id, :activity_id
    rename_column :activities_members, :members_id, :member_id
  end
end
