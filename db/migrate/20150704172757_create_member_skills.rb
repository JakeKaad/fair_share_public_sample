class CreateMemberSkills < ActiveRecord::Migration
  def change
    create_table :member_skills do |t|
      t.belongs_to :member
      t.belongs_to :skill
    end
  end
end
