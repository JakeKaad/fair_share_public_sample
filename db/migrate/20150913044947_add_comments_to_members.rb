class AddCommentsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :comments, :text
  end
end
