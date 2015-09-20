class AddArchivedToMembers < ActiveRecord::Migration
  def change
    add_column :members, :archived, :boolean
  end
end
