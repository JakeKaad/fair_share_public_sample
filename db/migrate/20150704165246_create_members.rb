class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :relationship_to_student
      t.string :email
      t.string :phone
      t.belongs_to :family
    end
  end
end
