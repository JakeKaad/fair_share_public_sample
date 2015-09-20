class DropMembersSkillsTable < ActiveRecord::Migration
  def change
    drop_table :members_skills
  end
end
