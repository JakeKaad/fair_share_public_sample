class CreateMemberInterests < ActiveRecord::Migration
  def change
    create_table :member_interests do |t|
      t.belongs_to :member
      t.belongs_to :interest
    end
  end
end
