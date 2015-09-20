class CreateActivitiesMembers < ActiveRecord::Migration
  def change
    create_table :activities_members do |t|
      t.belongs_to :activities
      t.belongs_to :members
      t.timestamps
    end
  end
end
