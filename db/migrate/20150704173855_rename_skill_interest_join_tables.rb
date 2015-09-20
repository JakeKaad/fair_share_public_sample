class RenameSkillInterestJoinTables < ActiveRecord::Migration
  def change
    rename_table :member_interests, :interests_members
    rename_table :member_skills, :members_skills
  end
end
